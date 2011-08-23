methods_for :rpc do
  [:send_action, :introduce, :originate, :call_into_context, :call_and_exec, :ping].each do |method_name|
    define_method("restful_#{method_name}") do |*args|
      if VoIP::Asterisk.manager_interface
        response = VoIP::Asterisk.manager_interface.send(method_name, *args)
        {:result => true}
      else
        ahn_log.ami_remote.error "AMI has not been enabled in startup.rb!"
        {:result => false}
      end
    end
  end

  # Helps the GUI determine whether the call is still active.
  def call_with_destination(destination)
    ahn_log.click_to_call "Finding call with destination #{destination.inspect} in #{Adhearsion.active_calls.size} active calls"
    status = find_call_by_destination(destination) ? "alive" : "dead"
    {:result => status}
  end

  # Traverses Adhearsion's data structure for active calls and returns
  # the proper channel name that Asterisk needs to hangup a call.
  def hangup_channel_with_destination(destination)
    if found_call = find_call_by_destination(destination)
      Adhearsion::VoIP::Asterisk.manager_interface.hangup found_call.variables[:channel]
      {:channel => found_call.variables[:channel]}
    else
      nil
    end
  end

  def find_call_by_destination(destination)
    Adhearsion.active_calls.to_a.find do |call|
      call.variables[:destination].include? destination
    end
  end
end
