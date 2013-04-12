require "integrations/requests/apiary/7_gel_plate_resource/spec_helper"
describe "create_a_new_gel_plate" do
  include_context "use core context service"
  it "create_a_new_gel_plate" do
  # **Create a new gel plate.**
  # 
  # * `number_of_rows` number of rows in the gel plate
  # * `number_of_columns` number of columns in the gel plate
  # * `windows_description` map tubes identified by their uuids to rack locations
    save_with_uuid Lims::Core::Laboratory::Sample.new(:name => 'sample 1') => [1,2,3,4,6]

    header('Accept', 'application/json')
    header('Content-Type', 'application/json')

    response = post "/gels", <<-EOD
    {
    "gel": {
        "number_of_rows": 8,
        "number_of_columns": 12,
        "windows_description": {
            "C5": [
                {
                    "sample": "11111111-2222-3333-4444-666666666666",
                    "type": "DNA",
                    "quantity": 10
                }
            ]
        }
    }
}
    EOD
    response.status.should == 200
    response.body.should match_json <<-EOD
    {
    "gel": {
        "actions": {
            "read": "http://example.org/11111111-2222-3333-4444-555555555555",
            "update": "http://example.org/11111111-2222-3333-4444-555555555555",
            "delete": "http://example.org/11111111-2222-3333-4444-555555555555",
            "create": "http://example.org/11111111-2222-3333-4444-555555555555"
        },
        "uuid": "11111111-2222-3333-4444-555555555555",
        "number_of_rows": 8,
        "number_of_columns": 12,
        "windows": {
            "A1": [

            ],
            "A2": [

            ],
            "A3": [

            ],
            "A4": [

            ],
            "A5": [

            ],
            "A6": [

            ],
            "A7": [

            ],
            "A8": [

            ],
            "A9": [

            ],
            "A10": [

            ],
            "A11": [

            ],
            "A12": [

            ],
            "B1": [

            ],
            "B2": [

            ],
            "B3": [

            ],
            "B4": [

            ],
            "B5": [

            ],
            "B6": [

            ],
            "B7": [

            ],
            "B8": [

            ],
            "B9": [

            ],
            "B10": [

            ],
            "B11": [

            ],
            "B12": [

            ],
            "C1": [

            ],
            "C2": [

            ],
            "C3": [

            ],
            "C4": [

            ],
            "C5": [
                {
                    "sample": {
                        "actions": {
                            "read": "http://example.org/11111111-2222-3333-4444-666666666666",
                            "update": "http://example.org/11111111-2222-3333-4444-666666666666",
                            "delete": "http://example.org/11111111-2222-3333-4444-666666666666",
                            "create": "http://example.org/11111111-2222-3333-4444-666666666666"
                        },
                        "uuid": "11111111-2222-3333-4444-666666666666",
                        "name": "sample 1"
                    },
                    "quantity": 10,
                    "type": "DNA",
                    "unit": "mole"
                }
            ],
            "C6": [

            ],
            "C7": [

            ],
            "C8": [

            ],
            "C9": [

            ],
            "C10": [

            ],
            "C11": [

            ],
            "C12": [

            ],
            "D1": [

            ],
            "D2": [

            ],
            "D3": [

            ],
            "D4": [

            ],
            "D5": [

            ],
            "D6": [

            ],
            "D7": [

            ],
            "D8": [

            ],
            "D9": [

            ],
            "D10": [

            ],
            "D11": [

            ],
            "D12": [

            ],
            "E1": [

            ],
            "E2": [

            ],
            "E3": [

            ],
            "E4": [

            ],
            "E5": [

            ],
            "E6": [

            ],
            "E7": [

            ],
            "E8": [

            ],
            "E9": [

            ],
            "E10": [

            ],
            "E11": [

            ],
            "E12": [

            ],
            "F1": [

            ],
            "F2": [

            ],
            "F3": [

            ],
            "F4": [

            ],
            "F5": [

            ],
            "F6": [

            ],
            "F7": [

            ],
            "F8": [

            ],
            "F9": [

            ],
            "F10": [

            ],
            "F11": [

            ],
            "F12": [

            ],
            "G1": [

            ],
            "G2": [

            ],
            "G3": [

            ],
            "G4": [

            ],
            "G5": [

            ],
            "G6": [

            ],
            "G7": [

            ],
            "G8": [

            ],
            "G9": [

            ],
            "G10": [

            ],
            "G11": [

            ],
            "G12": [

            ],
            "H1": [

            ],
            "H2": [

            ],
            "H3": [

            ],
            "H4": [

            ],
            "H5": [

            ],
            "H6": [

            ],
            "H7": [

            ],
            "H8": [

            ],
            "H9": [

            ],
            "H10": [

            ],
            "H11": [

            ],
            "H12": [

            ]
        }
    }
}
    EOD

  end
end
