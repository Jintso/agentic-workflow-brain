# A transcript from before turnPosition: each turnOrigin record starts a turn.
rec prompt-old 10:00:00
rec close      10:10:00 600000
rec prompt-old 10:20:00
rec close      10:25:00 300000
run session-times.sh s1
