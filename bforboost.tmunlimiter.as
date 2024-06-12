float boost_strength = 0.3; // the strength of the boost
bool boosting = false;

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

bool onBindInputEvent(TrackManiaRace@ race, BindInputEvent@ inputEvent, uint eventTime) {
    if ( inputEvent.getBindName() == "TMUnlimiter - Action Key 1" && inputEvent.getEnabled() ) {
        boosting = true;
    }
    if ( inputEvent.getBindName() == "TMUnlimiter - Action Key 1" && !inputEvent.getEnabled() ) {
        boosting = false;
    }
    
    return false;
}

void onTick(TrackManiaRace@ race) {
    if (boosting && getGroundContacts(race) > 0) {
        applyLocalForce(race, Vec3(0, 0, boost_strength));
    }
}
