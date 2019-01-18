require 'rest-client'
require 'json'

class DirectionService < BaseService
    def call(parameters)
        begin
            response = request_direction(parameters)
            steps = get_steps_from_response(response)
            if steps
                get_instructions_from_steps(steps)
            else
                {"error" => "No routes found"}
            end
        rescue
            false
        end
    end

    def request_direction(parameters)
        from = parameters[:from]
        to = parameters[:to]
        key = 'AIzaSyAd8jcurC1lh4m-1h9Xo4gkoti-xJGj2-8'
        mode = 'transit'
        region = '.vn'
        url = "https://maps.googleapis.com/maps/api/directions/json?origin=#{from}&destination=#{to}&key=#{key}&mode=#{mode}&region=#{region}"

        response = RestClient.get url

        JSON.parse response.body
    end

    def get_steps_from_response(response)
        begin
            response["routes"][0]["legs"][0]["steps"]
        rescue
            false
        end
    end

    def get_instructions_from_steps(steps)
        instructions = []

        steps.each do |step|
            instruction = parse_instruction_from_html step["html_instructions"]
            instruction = add_bus_instruction(step, instruction) if transit_exists? step  

            instructions.push instruction
            instructions.push get_instructions_from_steps(step["steps"]) if more_sub_steps? step
        end

        return instructions
    end

    def parse_instruction_from_html(html_instructions)
        html_instructions.gsub(/(<div\s(.*?)>|<div>)/,'. ').gsub(/(<(.*?)>)|(&nbsp;)/, '').gsub(/&amp;/,'&');
    end

    def add_bus_instruction(step, instruction)
        "There should be a bus stop right there. Bus Route: " + get_transit_line_name(step) + ". Ask staffs to stop by: " + get_arrival_stop_name(step)   
    end

    def arrival_stop_exists?(step)
        begin 
            get_arrival_stop_name step
        rescue
            false
        end
    end

    def get_arrival_stop_name(step)
        step["transit_details"]["arrival_stop"]["name"]
    end

    def get_transit_line_name(step)
        step["transit_details"]["line"]["name"] 
    end

    def transit_exists?(step)
        begin 
            get_transit_line_name step
        rescue
            false
        end
    end

    def more_sub_steps?(step)
        step["steps"]
    end
end