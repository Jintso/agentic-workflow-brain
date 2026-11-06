# Gap 20: a headless session (claude -p) writes no turn_duration. A turn ends at its last record before the next turn starts, leaving out the queue-operations the next prompt writes.
rec queued 09:59:59
rec prompt 10:00:00 1
rec reply  10:20:00
rec queued 10:59:59            # the second claude -p, an hour later
rec prompt 11:00:00 2
rec reply  11:10:00
run session-times.sh s1
