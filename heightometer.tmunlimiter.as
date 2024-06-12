void setMediaTrackerText(TrackManiaRace@ race, int clipIndex, int blockIndex, string text) {
    auto clip_player = race.inGameClipPlayer;
    auto mtctracks = clip_player.clip.tracks;
    auto block = mtctracks[clipIndex].blocks[blockIndex];
    if (block.isVisible()) block.text_setText(text);
}

GameBlock@ highestBlock = null;

void onTick(TrackManiaRace@ race)
{
    auto dyna = race.getPlayingPlayer().vehicleCar.hmsDyna;
    setMediaTrackerText(race, 0, 0, "Height: "+int(dyna.currentState.location.y)+" ("+int(100 * (dyna.currentState.location.y / (highestBlock.coord.y*8)))+"%)");
}

void onStart(TrackManiaRace@ race) {
    auto blocks = race.challenge.blocks;
    @highestBlock = blocks[0];

    for (uint i = 0; i < blocks.length; i++){
        auto block = blocks[i];
        if (block.coord.y > highestBlock.coord.y){
            @highestBlock = block;
        }
    }
}