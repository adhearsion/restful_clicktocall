# Click to Call

## Description

Example component for Adhearsion showing a click to call application. Also shows how to use the RESTful API of Adhearsion.

## Example

Place this in your dialplan.rb of your Adhearsion project:

```ruby
  adhearsion {
    self.call.variables[:destination] = get_variable("destination")
    dial self.call.variables[:destination]
  }
```

## Installation

1. Install the [http://github.com/jsgoecke/restful_adhearsion](RESTful-Adhearsion) client library gem:

    sudo gem install jsgoecke-restful_adhearsion --source=http://gems.github.com/

2. In your components directory of your Adhearsion project:

    git clone git://github.com/jsgoecke/restful_clicktocall.git

3. Then add the example code from above to your ~adhearsion-project/dialplan.rb.

4. Enable the restful_rpc component from within your ~adhearsion-project/ directory:

    ahn enable component restful_rpc

5. From within the directory ~adhearsion-project/components/restful_clicktocall/web run:

    ruby run_me.rb

6. Connect to the web form:

    http://localhost:4567

Then you are off and running!

7. If you would like to run Sinatra as a daemon, I recommend you use Rack and Passenger

Simply do the following:

* Install the Apache Webserver
* gem install rack
* gem install passenger (follow instructions [http://www.modrails.com/install.html](here)

Copy the files and directories in ~ahn-project/components/restful_clicktocall/web to the appropriate location on your Apache web server. Add this virtual host settings to your Apache configuration:

```
  <VirtualHost *:80>
    ServerName your.website.com
    DocumentRoot /var/www/restful\_clicktocall\_web/public
  </VirtualHost>
```

Restart your Apache web server and then connect to the site you configured. For more options I recommend referring to the Passenger documentation found [http://www.modrails.com/documentation/Users%20guide.html](here).
