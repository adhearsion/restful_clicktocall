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

1. In your components directory of your Adhearsion project:

    `git clone git://github.com/adhearsion/restful_clicktocall.git`

2. Add the example code from above to your `adhearsion-project/dialplan.rb`.

3. Add the restful_rpc component to your Gemfile and `startup.rb` gem component configuration:
    ```ruby
      group :components do
        gem 'ahn-restful-rpc'
      end
    ```

    and

    `config.add_component 'ahn-restful-rpc'`

4. Copy the example component config from [here](https://github.com/adhearsion/ahn-restful-rpc/blob/develop/config/ahn-restful-rpc.yml) to `adhearsion-project/config/components/ahn-restful-rpc.yml`

4. From within the directory `adhearsion-project/components/restful_clicktocall/web` run:

    `bundle install && bundle exec rackup`

5. Connect to the web form:

    `http://localhost:9292`

Then you are off and running!

6. If you would like to run Sinatra as a daemon, I recommend you use Rack and Passenger

Simply do the following:

* Install the Apache Webserver
* gem install rack
* gem install passenger (follow instructions [here](http://www.modrails.com/install.html))

Copy the files and directories in `ahn-project/components/restful_clicktocall/web` to the appropriate location on your Apache web server. Add this virtual host settings to your Apache configuration:

```
  <VirtualHost *:80>
    ServerName your.website.com
    DocumentRoot /var/www/restful_clicktocall_web/public
  </VirtualHost>
```

Restart your Apache web server and then connect to the site you configured. For more options I recommend referring to the [Passenger documentation](http://www.modrails.com/documentation/Users%20guide.html).
