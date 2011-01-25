def generate_problem(mode, n)
  buf = ""
  n.times do
    x1 = rand(10)
    x2 = rand(10)
    ans = x1 + x2
    prob_str = "#{x1}+#{x2}="
    ans_str = ans.to_s
    buf += prob_str.length.chr + ans_str.length.chr + prob_str + ans_str
  end
  buf
end
