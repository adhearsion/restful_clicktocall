# Create our Adhearsion object connected to the RESTful API of Adhearsion
Adhearsion = RESTfulAdhearsion.new :host => "localhost",
                                   :port => 5000,
                                   :user => "jicksta",
                                   :password => "roflcopterz"

# You'll need to change this for your own format.
# Note: this will soon be handled by the Call Routing DSL in Adhearsion.
def format_number(number)
  "SIP/#{number}"
end

post "/call" do
  # Originates a call over the AMI interface
  Adhearsion.originate :channel  => format_number(params[:source]),
                       :context  => "adhearsion",
                       :priority => "1",
                       :exten    => "1000",
                       :async    => 'true',
                       :variable => "destination=#{format_number params[:destination]}"

  "ok".to_json
end

post "/hangup" do
  # Get the channel of the active call, then hang it up
  Adhearsion.hangup_channel_with_destination params[:call_to_hangup]
  "ok".to_json
end

get '/status' do
  Adhearsion.call_with_destination(params[:destination]).to_json
end

get '/' do
  #Build our web form that has the JQuery sprinkled in
  <<-HTML
<html>
  <head>
    <title>Click to Call Demo</title>

    <script src="jquery.js" type="text/javascript"></script>
    <script src="call.js" type="text/javascript"></script>
    <link href="style.css" media="screen" rel="stylesheet" type="text/css" />
  </head>

  <body>
    <div id="content">
      <h1>Click to Call Demo</h1>

      <h2>Bridge two people together</h2>

      <div id="call-form">
        <p><label for="source">Primary party: </label><input type="text" id="source" name="source"/></p>
        <p><label for="destination">Second party: </label><input type="text" name="destination" id="destination"/></p>
        <p><button onclick="new AhnCall($('#call'), $('#source').val(), $('#destination').val())">Start call</button></p>
      </div>
    </div>

    <div id="call" class="hidden">
      <p>Starting...</p>
    </div>
  </body>
</html>
  HTML
end
