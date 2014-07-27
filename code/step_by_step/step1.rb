require 'gosu'

WINDOW_HEIGHT = 600
WINDOW_WIDTH  = 800

class GameWindow < Gosu::Window
  def initialize
    super(WINDOW_WIDTH, WINDOW_HEIGHT, false)
  end

  def draw
    p "drawing ..."
  end

  def update
    p "updating ..."
  end
end

window = GameWindow.new
window.show