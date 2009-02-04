// Written by Jay Phillips

// The "viewer_element" arg should be a <div> with one <p> child that's hidden by default.
function AhnCall(viewer_element, source, destination) {
  this.viewer      = viewer_element;
  this.text_holder = $(viewer_element.children()[0]);
  
  this.source      = source;
  this.destination = destination;
  
  this.viewer.slideDown();
  
  var self = this;
  
  // Using the more sophisticated jQuery.ajax method instead of jQuery.post in order to handle errors.
  jQuery.ajax({
    url:  "call",
    type: "POST",
    success: function(event) { self.transition_to("ringing") },
    error:   function(event) { self.transition_to("error")   },
    data:    { "destination": self.destination, "source": self.source }
  });
  
  // Possible states: new, connecting, error, ringing, established, hanging_up, finished
  self.state = "new";
  
  self.transition_to = function(new_state) {
    self.state = new_state;
    self.state_transitions[new_state]();
  };
  
  self.state_transitions = {
    
    connecting: function() {
      self.update_text("Connecting");
      self.viewer.removeClass("hidden");
      self.viewer.children("button").remove();
      self.viewer.slideDown("slow");
    },
    
    ringing: function() {
      self.update_text("Ringing");
      self.queue_next_heartbeat(false);
    },
    
    established: function() {
      self.update_text("Call in progress!");
      self.viewer.append(self.get_hangup_button());
    },
    
    hanging_up: function() {
      self.update_text("Hanging up");
    },
    
    finished: function() {
      self.update_text("Call finished");
      self.viewer.children("button").remove();
      self.viewer.append(self.viewer_hide_button());
    },
    
    error: function() {
      self.update_text("Whoops. Error occurred!");
      self.viewer.children("button").remove();
      self.viewer.append(self.viewer_hide_button());
    }
  };
  
  self.viewer_hide_button = function() {
    hide_link = $(document.createElement("button"));
    hide_link.text("Hide");
    hide_link.click(function() { self.viewer.slideUp(); });
    return hide_link;
  };

  self.get_hangup_button = function() {
    if(!self.hangup_button) {
      self.hangup_button = $(document.createElement("button"));
      self.hangup_button.text("Hangup");
      self.hangup_button.click(function() {
        self.hangup();
      });
    }
    return self.hangup_button;
  };
  
  self.update_text = function(new_text) {
    self.text_holder.text(new_text);
  };
  
  self.heartbeat = function(has_been_answered) {
    jQuery.getJSON("status", {destination: self.destination}, function(data) {
      call_status = data.result;
      if(call_status == "alive") {
        if(self.state == "connecting" || self.state == "ringing") {
          self.transition_to("established");
        }
        self.queue_next_heartbeat(true);
      } else if(call_status == "dead") {
        if(has_been_answered) {
          self.transition_to("finished")
          // Do not queue next heartbeat
        } else {
          self.queue_next_heartbeat(false)
        }
      } else {
        throw "Unrecognized call status " + call_status + "!";
      }
    });
  };
  
  self.heartbeat_timeout = 1000;
  
  self.queue_next_heartbeat = function(has_been_answered) {
    //var has_been_answered = has_been_answered;
    setTimeout(function() { self.heartbeat(has_been_answered) }, self.heartbeat_timeout);
  };

  self.hangup = function() {
    self.transition_to("hanging_up");
    jQuery.ajax({
      url: "hangup",
      type: "POST",
      success: function(event) { self.transition_to("finished") },
      error:   function(event) { self.transition_to("error")    },
      data: { "call_to_hangup": self.destination }
    });
  };
  
  self.transition_to("connecting");
  
}