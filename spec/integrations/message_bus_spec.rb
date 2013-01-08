require 'rubygems'
require 'bunny'
require 'lims-core'
require 'integrations/spec_helper'


def order_expected_payload(args)
  action_url = "http://example.org/#{args[:uuid]}"
  user_url = "http://example.org/#{args[:user_uuid]}"
  study_url = "http://example.org/#{args[:study_uuid]}"

  {:order => {
    :actions => {:read => action_url, :create => action_url, :update => action_url, :delete => action_url},
    :uuid => args[:uuid], 
    :creator => {
      :actions => {:read => user_url, :create => user_url, :update => user_url, :delete => user_url},
      :uuid => args[:user_uuid] 
    },
    :pipeline => args[:pipeline],
    :status => args[:status],
    :parameters => args[:parameters],
    :state => args[:state],
    :study => {
      :actions => {:create => study_url, :delete => study_url, :read => study_url, :update => study_url},
      :uuid => args[:study_uuid] 
    },
    :cost_code => args[:cost_code],
    :items => args[:items]
  },
  :action => args[:action]} 
end


shared_examples_for "messages on the bus" do 
  it "has the right number of message" do
    @messages.length.should == expected_messages.length     
  end

  it "generates the right routing_key" do
    @messages.each_with_index do |m, i|
      @messages[i][:routing_key].should == expected_messages[i][:routing_key]
    end
  end

  it "publishes the right messages" do
    @messages.each_with_index do |m, i|
      JSON.parse(@messages[i][:payload]).should match_json(expected_messages[i][:payload])
    end 
  end
end


shared_context "save resource" do 
  let!(:create_result) { post(create_url, parameters.to_json) }
end


shared_context "update resource" do
  let!(:update_result) { put(update_url, update_parameters.to_json) }
end


describe "Message Bus" do
  include_context "use core context service", :items, :orders, :studies, :users, :uuid_resources 
  include_context "JSON"
  include_context "use generated uuid"

  let(:study_uuid) { "55555555-2222-3333-6666-777777777777".tap do |uuid|
    store.with_session do |session|
      study = Lims::Core::Organization::Study.new
      set_uuid(session, study, uuid)
    end
  end
  } 

  let(:user_uuid) { "66666666-2222-4444-9999-000000000000".tap do |uuid|
    store.with_session do |session|
      user = Lims::Core::Organization::User.new
      set_uuid(session, user, uuid)
    end
  end
  }
  let(:create_url) { "/orders" }
  let(:create_action) { "create" }
  let(:order_items) { {
    :source_role1 => { :status => "done", :uuid => "99999999-2222-4444-9999-000000000000"},
    :target_role1 => { :status => "pending", :uuid => "99999999-2222-4444-9999-111111111111"}} 
  }
  let(:order_parameters) { {} }
  let(:order_state) { {} }
  let(:order_status) { "draft" }
  let(:order_cost_code) { "cost code" }
  let(:order_pipeline) { "pipeline" }
  let(:parameters) { {:order => {:user_uuid => user_uuid,
                                 :study_uuid => study_uuid,
                                 :sources => {:source_role1 => "99999999-2222-4444-9999-000000000000"},
                                 :targets => {:target_role1 => "99999999-2222-4444-9999-111111111111"},
                                 :cost_code => order_cost_code,
                                 :pipeline => order_pipeline}} }
  let(:payload_parameters) {{
    :uuid => uuid,
    :study_uuid => study_uuid,
    :user_uuid => user_uuid,
    :pipeline => order_pipeline,
    :status => order_status,
    :parameters => order_parameters,
    :state => order_state,
    :cost_code => order_cost_code,
    :items => order_items
  }}
  let(:create_payload) { order_expected_payload(payload_parameters.merge({:action => create_action})) }


  context "on valid order creation" do
    let(:create_action) { "create" }
    let(:expected_messages) { [{:routing_key => "pipeline.66666666222244449999000000000000.order.create", :payload => create_payload}]}
    include_context "save resource"
    it_behaves_like "messages on the bus"  
  end


  context "on valid order creation and update" do
    let(:update_url) { "/#{uuid}" }     
    let(:update_action) { "update_order" }
    let(:update_parameters) { {:event => :build} }
    let(:update_payload) { order_expected_payload(payload_parameters.merge({:action => update_action, :status => "pending"})) }
    let(:expected_messages) { [{:routing_key => "pipeline.66666666222244449999000000000000.order.create", :payload => create_payload},
       {:routing_key => "pipeline.66666666222244449999000000000000.order.updateorder", :payload => update_payload}] }

    include_context "save resource"
    include_context "update resource"
    it_behaves_like "messages on the bus"
  end
end
