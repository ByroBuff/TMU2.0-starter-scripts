float mouseX = 0;

bool onBindInputEvent(TrackManiaRace@ race, BindInputEvent@ inputEvent, uint eventTime){
  if (inputEvent.getBindName() == "_MouseX"){
    mouseX = inputEvent.getAnalog();
  }
  return false;
}


void onVehicleInputEvent(TrackManiaRace@ race, VehicleInputEvent@ inputEvent, uint eventTime){
  if (inputEvent.getInputType() == VehicleInputEvent::InputType::Steer){
    inputEvent.setAnalog(mouseX);
  }
}