class WelcomeController < ApplicationController
  protect_from_forgery except: [:start]

  def index
    render text: 'this is line bot'
  end

  def start
    text = params['result'].first['content']['text']
    to = params['result'].first['content']['from']

    if text.nil?
      Line.echo to, '24分集中開始！'
      1.upto(23).each do |i|
        sleep 1 * 60
        Line.echo to, "あと#{24-i}分！"
      end
      sleep 1 * 60
      Line.echo to, '終了です！お疲れ様でした。５分間ゆっくり休んでください♡'
      sleep (5 * 60) 
      Line.echo to, '休憩時間終了です。また24分頑張ってくださいっ！' 
    else
      disp = "「#{text}」を開始するのですね！"
      pres = Worklog.where(user_key: to).order('created_at desc')
      if pres.present?
        pre = pres.first
        sec = (Time.now - pre.created_at).to_i
        hour = (sec / (60 * 60)).to_i
        remain = (sec - hour * 60 * 60)
        min  = (remain / 60 ).to_i
        sec  = remain - 60*min
        if hour > 0
          duration = "#{hour}時間#{min}分#{sec}秒"
        elsif min > 0
          duration = "#{min}分#{sec}秒"
        else
          duration = "#{sec}秒"
        end
        disp += "\n前回の「#{pre.name}」は#{duration}でした"
      end

      Worklog.create!(user_key: to, name: text)
      Line.echo to, disp
    end
  end
end

