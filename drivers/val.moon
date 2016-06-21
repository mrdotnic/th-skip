VALBATCHES = 20

(model, workers, opts, state) ->
  {:gpuSents, :gpuPrevSents, :gpuNextSents, :crit} = state

  -- N = VALBATCHES * opts.batchSize

  ->
    model\evaluate!

    saveseed = torch.random!
    math.randomseed(1234)
    torch.manualSeed(1234)

    valLoss = 0

    for i=1,VALBATCHES
      workers\addjob (-> dataLoader\makebatch 'val'),
        (batchSents, batchPrevSents, batchNextSents) ->
          gpuSents\resize(batchSents\size!)\copy(batchSents)
          gpuPrevSents\resize(batchPrevSents\size!)\copy(batchPrevSents)
          gpuNextSents\resize(batchNextSents\size!)\copy(batchNextSents)

          input = {gpuSents, gpuPrevSents, gpuNextSents}
          target = {gpuPrevSents\t!\sub(2, -1), gpuNextSents\t!\sub(2, -1)}

          model\forward(input)
          valLoss += crit\forward(model.output, target)

    workers\synchronize!

    math.randomseed(saveseed)
    torch.manualSeed(saveseed)

    state.valPerf = valLoss
    print string.format('Val loss: %g', valLoss)

    collectgarbage!
