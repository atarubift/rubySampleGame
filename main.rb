require 'dxopal'
include DXOpal

GROUND_Y = 400

# 使いたい画像を宣言する
Image.register(:player, 'images/player.png')

Window.load_resources do

  # 変数の初期化
  x = Window.width / 2 # 初期値を中心にする 

  Window.loop do

    # キー入力をチェック
    if Input.key_down?(K_LEFT) && x > 0
      x -= 8
    elsif Input.key_down?(K_RIGHT) && x < (Window.width - Image[:player].width)
      x += 8
    end

    # 背景を描画
    Window.draw_box_fill(0, 0, Window.width, GROUND_Y, [128, 255, 255])
    Window.draw_box_fill(0, GROUND_Y, Window.width, Window.height, [0, 128, 0])

    # プレイヤーキャラを描画
    Window.draw(x, GROUND_Y - Image[:player].height, Image[:player])
  end
end
