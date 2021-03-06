import dofile from require 'moonscript'
import thisfile from require 'paths'

DATA_DIR = thisfile 'data'

parse = (arg={}) ->
  cmd = with torch.CmdLine!
    \text!
    \text 'Options'

    \option '-decoding', '', 'Train decoder using this model'

    \option '-seed', 4242, 'Manual random seed'

    -- Data
    \option '-dataset', DATA_DIR..'/dataset.h5', 'path to dataset'
    \option '-w2v', DATA_DIR..'/vocab.bin', 'path to w2v'


    \option '-nworkers', 4, 'number of data loading threads'
    \option '-gpu', 0, 'index of the GPU to use'
    \option '-batchSize', 384, 'mini-batch size'

    -- Model
    \option '-rnnType', 'lstm', 'lstm or gru'
    \option '-dim', 1200, 'RNN dimension'
    \option '-bidir', 0, 'Use bidirectional RNN?'
    \option '-sentlen', 40, 'maximum sequence length'
    \option '-nEncRNNs', 1, 'number of stacked encoder RNNs'
    \option '-nDecRNNs', 1, 'number of stacked decoder RNNs'
    \option '-vocabSize', 20000, 'how many words to use'

    -- Training
    \option '-lr', 0.001, 'learning rate'
    \option '-optim', 'adam', 'optimizer to use (adam|sgd)'
    \option '-niters', -1, 'number of iterations for which to run (-1 is forever)'
    \option '-dispfreq', 100, 'number of iterations between printing train loss'
    \option '-valfreq', 500, 'number of iterations between validations'

    -- Saving & loading
    \option '-savefreq', -1, 'number of iterations between snapshots (-1 is infinite)'
    \option '-snapfile', 'snaps/snap', 'snapshot file prefix'
    \option '-saveafter', 0, 'how long before considering to save (-1 is immediately)'
    \option '-loadsnap', '', 'file from which to load model'
    \option '-rundesc', '', 'description of what is being tested'

    \text!

  cmd\parse arg

{ :parse }
