methods_for :rpc do
  # This method helps the GUI determine whether the call is still active.
  def call_with_destination(destination)
    ahn_log.click_to_call "Finding call with destination #{destination.inspect} in #{Adhearsion.active_calls.size} active calls"
    status = Adhearsion.active_calls.to_a.find do |call|
      call.variables[:destination].include? destination
    end ? "alive" : "dead"
    {:result => status}
  end

  # This method traverses Adhearsion's data structure for active calls and returns
  # the proper channel name that Asterisk needs to hangup a call.
  def hangup_channel_with_destination(destination)
    found_call = Adhearsion.active_calls.to_a.find do |call|
      call.variables[:destination].include? destination
    end
    if found_call
      Adhearsion::VoIP::Asterisk.manager_interface.hangup found_call.variables[:channel]
      {:channel => found_call.variables[:channel]}
    else
      nil
    end
  end

end