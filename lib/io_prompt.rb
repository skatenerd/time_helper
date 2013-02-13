class IOPrompt
  def self.prompt_float(prompt)
    puts prompt
    float_input = gets.to_f
    if float_input == 0.0
      puts "Please enter a number"
      return prompt_float(prompt)
    end

    return float_input
  end
end
