require 'gosu'

WINDOW_HEIGHT = 600
WINDOW_WIDTH  = 800
PALETTE = [ 0xff00EE7C, 0xffFF1AD9, 0xffFF401A, 0xffFAFF39, 0xff2A4CFF]

class GameObject
  attr_accessor :image, :x, :y, :velocity

  def initialize(window, x = 100, y = WINDOW_HEIGHT/2, velocity = 0, color = 0xffffffff)
    @image = Gosu::Image.new(window, "media/player.png")
    @x, @y, @velocity, @color = x, y, velocity, color
  end

  def hitbox
    hitbox_x = ((@x - 50).to_i..(@x + 50).to_i).to_a
    hitbox_y = ((@y - 50).to_i..(@y + 50).to_i).to_a
    {x: hitbox_x, y: hitbox_y}
  end

  def draw
    @image.draw_rot(@x, @y, 0, @x/2, 0.5, 0.5, 1, 1, @color)
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

    @background = Gosu::Image.new(self, "media/background.png")
    @crash_sound = Gosu::Sample.new(self, "media/crash3.wav")
    @music = Gosu::Song.new(self, "media/music.mp3")

    @player = Player.new(self)
    @enemies = (0..3).map { |index|  Enemy.new(self, index)}

    @velocity = @background_x = 0

    @music.play(true)
  end

  def update
    if button_down? Gosu::KbUp
      @player.y = [@player.y + 10, WINDOW_HEIGHT].min
    elsif button_down? Gosu::KbDown
      @player.y = [@player.y - 10, 0].max
    end

    if button_down? Gosu::KbRight
      accelerate
    elsif button_down? Gosu::KbLeft or button_down? Gosu::KbSpace
      decelerate
    end

    @enemies.each { |e| e.move(@velocity) }
    scroll_background
    detect_collisions
  end

  def accelerate
    @velocity += 0.001
  end

  def decelerate
    @velocity = [@velocity - 0.01, 0].max
  end

  def scroll_background
    @background_x -= 100 * @velocity
    @background_x = 0 if @background_x < -(WINDOW_HEIGHT)
  end

  def detect_collisions
    @crash_sound.play(0.15) if  @enemies.map { |enemy| collision?(enemy, @player) }.any?
  end

  def draw
    @background.draw(@background_x, 0, 0)
    @player.draw
    @enemies.map(&:draw)
  end
end


class Player < GameObject

  def initialize(window)
    super(window)
  end
end

class Enemy < GameObject

  def initialize(window, index = 0)
     @calculate_y = [
      lambda { 200 + 150 * Math.cos(@x/100) },
      lambda { 200 + 150 * Math.sin(@x/100) },
      lambda { @x/ 2 },
      lambda { @x/-2 }
    ][index]
    super(window, WINDOW_WIDTH + index * 200, WINDOW_HEIGHT + 100, 0, PALETTE[index])
  end

  def move(velocity)
    @x -= 100 * velocity
    @y = @calculate_y.call

    @x = WINDOW_WIDTH + 30 * rand(1..4) if @x < -100
    @y %= WINDOW_HEIGHT
  end
end

window = GameWindow.new
window.show