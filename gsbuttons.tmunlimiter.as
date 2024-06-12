int getGroundContacts(TrackManiaRace@ race) {
    // function by spiderfffun
    auto Player = race.getPlayingPlayer();
    auto vehicleCar = Player.get_vehicleCar();       
    int groundContacts = 0;
    
    for (uint i = 0; i < vehicleCar.getWheelCount(); i++)
    {
        auto wheel = vehicleCar.getWheel(i).realTimeState.groundContactsCount;
        groundContacts += wheel > 0 ? 1 : 0;
    }
    return groundContacts;
}

void applyLocalForce(TrackManiaRace@ race, Vec3 force) {
    auto Player = race.getPlayingPlayer();
    auto car = Player.get_vehicleCar();
    auto dynamics = car.get_hmsDyna().currentState;

    Vec3 linearSpeed = dynamics.linearSpeed;
    Mat3 matrix;

    matrix.set( dynamics.rotation );
    linearSpeed.x += matrix.x.x * force.x;
    linearSpeed.y += matrix.y.x * force.x;
    linearSpeed.z += matrix.z.x * force.x;

    linearSpeed.x += matrix.x.y * force.y;
    linearSpeed.y += matrix.y.y * force.y;
    linearSpeed.z += matrix.z.y * force.y;

    linearSpeed.x += matrix.x.z * force.z;
    linearSpeed.y += matrix.y.z * force.z;
    linearSpeed.z += matrix.z.z * force.z;

    dynamics.linearSpeed = linearSpeed;
}

void applyLocalRotation(TrackManiaRace@ race, Vec3 rotation) {
    auto Player = race.getPlayingPlayer();
    auto car = Player.get_vehicleCar();
    auto dynamics = car.get_hmsDyna().currentState;

    Vec3 angularSpeed = dynamics.angularSpeed;
    Mat3 matrix;

    matrix.set( dynamics.rotation );
    angularSpeed.x += matrix.x.x * rotation.x;
    angularSpeed.y += matrix.y.x * rotation.x;
    angularSpeed.z += matrix.z.x * rotation.x;

    angularSpeed.x += matrix.x.y * rotation.y;
    angularSpeed.y += matrix.y.y * rotation.y;
    angularSpeed.z += matrix.z.y * rotation.y;

    angularSpeed.x += matrix.x.z * rotation.z;
    angularSpeed.y += matrix.y.z * rotation.z;
    angularSpeed.z += matrix.z.z * rotation.z;

    dynamics.angularSpeed = angularSpeed;
}

bool onBindInputEvent(TrackManiaRace@ race, BindInputEvent@ inputEvent, uint eventTime) {

    auto player = race.getPlayingPlayer();
    auto car = player.get_vehicleCar();
    auto dynamics = car.get_hmsDyna().currentState;
    auto tunings = car.get_carTunings();
    auto tuning = tunings.getTuningFromIndex(tunings.getCurrentTuningIndex());
    float jumpImpulseVal = tuning.jumpImpulseVal;
    auto cursor_pos = race.getCursorPos();

    if (getGroundContacts(race) > 0) {
        if ( inputEvent.getBindName() == "TMUnlimiter - Action Key 1" && inputEvent.getEnabled() ) {
            applyLocalForce(race, Vec3(0, 5, 0));
            applyLocalRotation(race, Vec3(0, 4, 0));
        }
        if ( inputEvent.getBindName() == "TMUnlimiter - Action Key 2" && inputEvent.getEnabled() ) {
            applyLocalForce(race, Vec3(0, 5, 0));
            applyLocalRotation(race, Vec3(0, -4, 0));
        }
    }
    
    return false;
}