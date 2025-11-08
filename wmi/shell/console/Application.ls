
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { create-instance } = dependency 'value.Instance'
    { sleep } = dependency 'os.shell.Script'
    { last-array-item } = dependency 'value.Array'
    { now } = dependency 'value.Date'

    { argtype } = create-error-context 'os.shell.console.Application'

    default-execution-statistics-analysis-algorithm = (context) ->

      { execution, background-processing } = context

      update-history = ->

        default-max-history-size = 30

        { max-history-size } = it ; if max-history-size is void => max-history-size = default-max-history-size ; it <<< { max-history-size }
        { duration-history } = it ; if duration-history is void => duration-history = [] ; it <<< { duration-history }

        { end, start } = it ; duration-history => ..push end - start ; if ..length > max-history-size => ..shift!

      cycle-duration = ({ duration-history }) -> last-array-item duration-history

      average-duration = ({ duration-history }) ->

        { length } = duration-history ; if length is 0 => return length

        sum = 0.0 ; for value in duration-history => sum = sum + value

        sum / length

      #

      update-history execution ; update-history background-processing

      cycle-execution-duration = cycle-duration execution ; cycle-background-processing-duration = cycle-duration background-processing
      average-execution-duration = average-duration execution ; average-background-processing-duration = average-duration background-processing

      actual-total-cycle-duration = cycle-execution-duration + cycle-background-processing-duration
      average-total-cycle-duration = average-execution-duration + average-background-processing-duration

      execution-statistics-analysis = {
        current-cycle: execution.cycle,
        cycle-execution-duration, cycle-background-processing-duration,
        average-execution-duration, average-background-processing-duration,
        average-total-cycle-duration, actual-total-cycle-duration
      }

    default-throttling-algorithm = (execution-statistics-analysis, context) ->

      { execution, background-processing } = context

      default-target-frame-rate = 30

      { duration-history, max-history-size } = execution

      sleep-duration = if duration-history.length < max-history-size

        20

      else

        { target-frame-rate } = execution ; if target-frame-rate is void => target-frame-rate = default-target-frame-rate ; execution <<< { target-frame-rate }
        { actual-total-cycle-duration } = execution-statistics-analysis

        target-frame-time = 1000 / target-frame-rate

        target-frame-time - actual-total-cycle-duration

      sleep Math.max 0, sleep-duration

    #

    create-application = ->

      finished = no

      create-instance do

        quit: method: -> finished := yes

        lifecycle: notifier: <[ on-startup before-execution after-execution on-idle on-error on-shutdown ]>

        start: method: (loop-handler) ->

          # try

          argtype '<Function|Undefined>' {loop-handler}

          context = application: @, background-processing: {}

          execution = cycles: 0, execution-statistics-analysis-algorithm: default-execution-statistics-analysis-algorithm, throttling-algorithm: default-throttling-algorithm

          context <<< { execution }

          @lifecycle.notify <[ on-startup ]> context

          loop

            try

            break if finished

            execution <<< start: now!

            @lifecycle.notify <[ before-execution ]> context

            loop-handler context if loop-handler isnt void

            @lifecycle.notify <[ after-execution ]> context

            execution <<< end: now!

            { background-processing } = context

            background-processing <<< start: now!

            @lifecycle.notify <[ on-idle ]> context

            background-processing <<< end: now!

            { execution-statistics-analysis-algorithm } = execution

            execution-statistics-analysis = execution-statistics-analysis-algorithm context

            { throttling-algorithm } = execution

            throttling-algorithm execution-statistics-analysis, context

            execution.cycles++

            # catch error => @lifecycle.notify <[ on-error ]> error, context

          # catch error => @lifecycle.notify <[ on-error ]> error, context

          # finally =>
          @lifecycle.notify <[ on-shutdown ]> context

    {
      create-application
    }