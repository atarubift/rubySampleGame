require 'dxopal'
include DXOpal

GROUND_Y = 400

# 主人公
Image.register(:player, 'images/player.png')
# リンゴ
Image.register(:apple, 'images/apple.png')
# ボム
Image.register(:bomb, 'images/bomb.png')
# サウンド
Sound.register(:get, 'sounds/get.wav')
Sound.register(:explosion, 'sounds/explosion.wav')

# スコアを記憶する
GAME_INFO = {
   score: 0 #現在のスコア
}

# プレイヤーを表すクラス
class Player < Sprite

  def initialize
    x = Window.width / 2
    y = GROUND_Y - Image[:player].height
    image = Image[:player]
    super(x, y, image)
    # 当たり判定を円で設定
    self.collision = [image.width / 2, image.height / 2, 16]
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

  def initialize(image)
    x = rand(Window.width - image.width) # x座標をランダムに設定
    y = 0
    super(x, y, image)
    @speed_y = rand(9) + 4 # 落下速度をランダムに設定
  end

  def update
    self.y += @speed_y
    if self.y > Window.height
      self.vanish
    end
  end
end

# 加点アイテムのクラス
class Apple < Item
  def initialize
    super(Image[:apple])

    # 衝突判定を円で設定
    self.collision = [image.width / 2, image.height / 2, 56]
  end

  # 衝突した時の処理
  def hit
    Sound[:get].play
    self.vanish
    GAME_INFO[:score] += 10
  end
end

# 妨害アイテムのクラス
class Bomb < Item
  def initialize
    super(Image[:bomb])

    # 衝突判定を円で設定
    self.collision = [image.width / 2, image.height / 2, 42]
  end

  # playerと衝突したとき呼ばれるメソッド
  def hit
    Sound[:explosion].play
    self.vanish
    GAME_INFO[:score] = 0 
  end
end

# アイテム群を管理するクラス
class Items

  # 同時に描画するアイテムの数
  N = 5

  def initialize 
    @items = []
  end

  def update(player)
    @items.each { |x| x.update(player) }
    # playerとitemが衝突しているかチェック。trueならhitが呼ばれる
    Sprite.check(player, @items)
    Sprite.clean(@items)

    # 消えた分を補充する
    (N - @items.size).times do
      # 40％の確率でリンゴ
      if rand(1..100) < 40
        @items.push(Apple.new)
      else
        @items.push(Bomb.new)
      end
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
    items.update(player)

    # 背景を描画
    Window.draw_box_fill(0, 0, Window.width, GROUND_Y, [128, 255, 255])
    Window.draw_box_fill(0, GROUND_Y, Window.width, Window.height, [0, 128, 0])

    # scoreを描画
    Window.draw_font(0,0, "SCORE: #{GAME_INFO[:score]}", Font.default)

    # プレイヤーキャラを描画
    player.draw

    # アイテムを描画
    items.draw
  end
end
