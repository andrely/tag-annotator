class MBTTrainer < Trainer
  @@default_name = 'mbt-train-tmp'
  @@mbtg_command = '/Users/stinky/Downloads/mbt-3.1.3/src/Mbtg'
  @@mbt_command = '/Users/stinky/Downloads/mbt-3.1.3/src/Mbt'
  
  def write_training_file(opts={})
    fold = opts[:fold] || nil
    name = opts[:name]

    filename = name + "#{('-' + fold.to_s) if fold}"


    File.open(filename, 'w') do |f|
      process_data(:fold => fold, :train => true) do |words|
        words.each { |w| f.puts "#{w.string}\t#{w.get_correct_tag.clean_out_tag}" }
        
        f.puts '<utt>'
      end
    end

    return filename
  end

  def write_eval_file(opts={})
    fold = opts[:fold] || nil
    name = opts[:name]

    filename = name + "-#{fold.to_s if fold}.eval"

    File.open(filename, 'w') do |f|
      process_data(:fold => fold, :eval => true) do |words|
        f.puts words.collect { |w| w.string }.join(' ')
      end
    end

    return filename
  end

  def exec_training_proc(opts={})
    name = opts[:name]
    fold = opts[:fold] || nil

    filename = name + "-#{fold.to_s if fold}"

    command = "#{@@mbtg_command} -T #{filename}"

    system(command)

    return MBTModel.new(:settings => name + '.settings')
  end

  def exec_result_proc(opts={})
    name = opts[:name]
    fold = opts[:fold] || nil

    result_file = name + "-#{fold.to_s if fold}.result"

    command = "#{@@mbt_command} -s #{name}.settings -t #{name}.eval > #{result_file}"

    system(command)

    return result_file
  end
end
