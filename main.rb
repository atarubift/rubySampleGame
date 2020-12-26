require 'dxopal'
include DXOpal

GROUND_Y = 400

Window.load_resources do
  Window.loop do
    # 背景を描画
    Window.draw_box_fill(0, 0, Window.width, GROUND_Y, [128, 255, 255])
    Window.draw_box_fill(0, GROUND_Y, Window.width, Window.height, [0, 128, 0])
  end
end
