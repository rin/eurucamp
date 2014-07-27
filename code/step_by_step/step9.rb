require 'gosu'

WINDOW_HEIGHT = 600
WINDOW_WIDTH  = 800

class GameObject
  attr_accessor :image, :x, :y

  def hitbox
    hitbox_x = ((@x - 50).to_i..(@x + 50).to_i).to_a
    hitbox_y = ((@y - 50).to_i..(@y + 50).to_i).to_a
    {x: hitbox_x, y: hitbox_y}
  end

end

class GameWindow < Gosu::Window
  def collision?(player, enemy)
    common_x = player.hitbox[:x] & enemy.hitbox[:x]
    common_y = player.hitbox[:y] & enemy.hitbox[:y]
    common_x.any? && common_y.any?
  end

  def initialize
    super(WINDOW_WIDTH, WINDOW_HEIGHT, false)
    @player = Player.new(self)
    @enemy  = Enemy.new(self)
    @background = Gosu::Image.new(self, "../media/background.png")
    @background_x = 0
  end

  def scroll_background
    @background_x -= 10
    @background_x = 0 if @background_x < -(WINDOW_HEIGHT)
  end

  def draw
    @background.draw(@background_x, 0, 0)
    @player.draw
    @enemy.draw
  end

  def update
    scroll_background
    if button_down? Gosu::KbUp
      @player.y = [@player.y - 10, 0].max
    elsif button_down? Gosu::KbDown
      @player.y = [@player.y + 10, 475].min
    end
    @enemy.move
    p "bumm!" if collision?(@player, @enemy)
  end
end

class Player < GameObject
  attr_accessor :y

  def initialize(window)
    @image = Gosu::Image.new(window, "../media/player.png")
    @x = 50
    @y = 250
  end

  def draw
    @image.draw(@x, @y, 0)
  end
end

class Enemy < GameObject
  def initialize(window)
    @image = Gosu::Image.new(window, "../media/player.png")
    @x = WINDOW_WIDTH
    @y = 0
  end

  def move
    @x -= 10
    @y = 400

    @x = WINDOW_WIDTH if @x < -100
  end

  def draw
    @image.draw(@x, @y, 0, 1, 1, 0xffff0000)
  end

end

window = GameWindow.new
window.show