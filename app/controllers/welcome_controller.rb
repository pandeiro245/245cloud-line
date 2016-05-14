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
      text = "「#{text}」を開始するのですね！"
      pres = Worklog.where(user_key: to).order('created_at desc')
      if pres.present?
        pre = pres.first
        duration = (Time.now - pre.created_at).to_i
        text += "\n「#{pre.name}」は#{duration}秒でした"
      end

      Worklog.create!(user_key: to, name: text)
      Line.echo to, text 
    end
  end
end

