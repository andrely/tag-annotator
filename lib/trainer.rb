class Trainer
  attr_accessor :tagged_text_id, :dir, :x_validation, :model, :train, :eval

  @@default_name = 'training-tmp'
  
  def initialize(tagged_text_id, opts={})
    @x_validation = opts[:x_validation] || nil
    @dir = opts[:dir] || Dir.tmpdir
    @train = opts[:train] || nil
    @eval = opts[:eval] || nil
    
    @tagged_text_id = tagged_text_id
  end
  
  def train()
    make_training_files

    train_model
  end

  def create_training_data(opts={})
    name = opts[:name] || @@default_name
    
    if @x_validation and @train
      10.times.collect { |i| write_training_file(:name => name, :fold => i)}
    elsif @train
      write_training_file(:name => name)
    end

    if @eval and @x_validation
      10.times.collect { |i| write_eval_file(:name => name, :fold => i)}
    elsif
      nil
    end
  end

  def write_training_file()
    raise NotImplementedError 'trainer#write_training_file'
  end

  def write_eval_file()
    raise NotImplementedError 'trainer#write_eval_file'
  end
  
  def process_data(opts={})
    fold = opts[:fold] || nil
    train = opts[:train] || nil
    eval = opts[:eval] || nil
    
    t = TaggedText.find(@tagged_text_id)
    raise RunTimeError if t.nil?
    
    t.sentences.each do |s|      
      yield s.words unless fold and s.text_index % 10 == fold and train
      yield s.words if fold and s.text_index % 10 == fold and eval
    end
  end

  def train_model(opts={})
    name = opts[:name] || @@default_name
    
    if @x_validation
      10.times.collect { |i| exec_training_proc :name => name, :fold => i }
    elsif
      nil # to be implemented
    end
  end

  def exec_training_proc()
    raise NotImplementedError
  end

  def eval_model(opts={})
    name = opts[:name] || @@default_name

    result_files = 10.times.collect { |i| exec_result_proc :name => name, :fold => i }

  end

  def exec_result_proc()
    raise NotImplementedError
  end
end
