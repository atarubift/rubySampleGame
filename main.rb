require 'dxopal'
include DXOpal

GROUND_Y = 400

# 主人公
Image.register(:player, 'images/player.png')
# アイテム
Image.register(:apple, 'images/apple.png')

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

# アイテムを表すクラス
class Item < Sprite

  def initialize
    image = Image[:apple]
    x = rand(Window.width - image.width) # x座標をランダムに設定
    y = 0
    super(x, y, image)
    @speed_y = rand(9) * 4 # 落下速度をランダムに設定
  end

  def update
    self.y += @speed_y
    if self.y > Window.height
      self.vanish
    end
  end
end

# アイテム群を管理するクラス
class Items

  # 同時に描画するアイテムの数
  N = 5

  def initialize 
    @items = []
  end

  def update
    # 各スプライトのupdateメソッドを呼ぶ
    Sprite.update(@items)
    # vanishしたスプライトを配列から取り除く
    Sprite.clean(@items)

    # 消えた分を補充する
    (N - @items.size).times do
      @items.push(Item.new)
    end
  end

  def draw
    # 各スプライトのdrawメソッドを呼ぶ
    Sprite.draw(@items)
  end
end


Window.load_resources do

  # オブジェクト作成
  player = Player.new
  items = Items.new

  Window.loop do

    # 移動
    player.update

    # アイテム作成・移動・削除
    items.update

    # 背景を描画
    Window.draw_box_fill(0, 0, Window.width, GROUND_Y, [128, 255, 255])
    Window.draw_box_fill(0, GROUND_Y, Window.width, Window.height, [0, 128, 0])

    # プレイヤーキャラを描画
    player.draw

    # アイテムを描画
    items.draw
  end
end
