require 'dxopal'
include DXOpal

GROUND_Y = 400

# 使いたい画像を宣言する
Image.register(:player, 'images/player.png')

# プレイヤーを表すクラス
class Player < Sprite

  def initialize
    x = Window.width / 2
    y = GROUND_Y - Image[:player].height
    image = Image[:player]
    super(x, y, image)
  end

  # 移動処理
  def update
    if Input.key_down?(K_LEFT) && self.x > 0
      self.x -= 8
    elsif Input.key_down?(K_RIGHT) && self.x < (Window.width - Image[:player].width)
      self.x += 8
    end
  end
end


Window.load_resources do

  # オブジェクト作成
  player = Player.new

  Window.loop do

    # 移動
    player.update

    # 背景を描画
    Window.draw_box_fill(0, 0, Window.width, GROUND_Y, [128, 255, 255])
    Window.draw_box_fill(0, GROUND_Y, Window.width, Window.height, [0, 128, 0])

    # プレイヤーキャラを描画
    player.draw
  end
end
