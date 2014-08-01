require 'gosu'

WINDOW_HEIGHT = 600
WINDOW_WIDTH  = 800
PALETTE = [ 0xff00EE7C, 0xffFF1AD9, 0xffFF401A, 0xffFAFF39, 0xff2A4CFF]

class GameWindow < Gosu::Window

  def initialize
    super(WINDOW_WIDTH, WINDOW_HEIGHT, false)

    @background = Gosu::Image.new(self, "media/background.png")
    @crash_sound = Gosu::Sample.new(self, "media/crash.wav")
    @music = Gosu::Song.new(self, "media/music.ogg")

    @player = Player.new(self)
    @enemies = (0..3).map { |index| Enemy.new(self, index)}

    @velocity = @background_x = 0

    @music.play(true)
  end

  def update
    if button_down? Gosu::KbDown
      @player.y = [@player.y + 10, WINDOW_HEIGHT].min
    elsif button_down? Gosu::KbUp
      @player.y = [@player.y - 10, 0].max
    end

    if button_down? Gosu::KbRight
      accelerate
    elsif button_down? Gosu::KbLeft or button_down? Gosu::KbSpace
      decelerate
    end

    @enemies.each { |e| e.move(@velocity) }
    scroll_background
    @crash_sound.play(0.15) if @enemies.map { |enemy| @player.collides_with?(enemy) }.any?
  end

  def accelerate
    @velocity += 0.001
  end

  def decelerate
    @velocity = [@velocity - 0.01, 0.01].max
  end

  def scroll_background
    @background_x -= 100 * @velocity
    @background_x = 0 if @background_x < -(WINDOW_HEIGHT)
  end

  def draw
    @background.draw(@background_x, 0, 0)
    @player.draw
    @enemies.map(&:draw)
  end
end

class Player
  attr_accessor :y

  def initialize(window)
    @image = Gosu::Image.new(window, "media/player.png")
    @x = 100
    @y = 400
  end

  def draw
    @image.draw(@x, @y, 0)
  end

  def collides_with?(enemy)
    Gosu::distance(@x, @y, enemy.x, enemy.y) < 100
  end
end

class Enemy
  attr_accessor :x, :y

  def initialize(window, index = 0)
     @image = Gosu::Image.new(window, "media/player.png")
     @x = WINDOW_WIDTH + index * 200
     @y = 0
     @color = PALETTE[index]
     @calculate_y = [
      lambda { 200 + 150 * Math.cos(@x/100) },
      lambda { 200 + 150 * Math.sin(@x/100) },
      lambda { @x/ 2 },
      lambda { @x/-2 }
    ][index]
  end

  def move(velocity)
    @x -= 200 * velocity
    @y = @calculate_y.call

    @x = WINDOW_WIDTH + 30 * rand(1..4) if @x < -100
    @y %= WINDOW_HEIGHT
  end

  def draw
    @image.draw_rot(@x, @y, 0, @x/2, 0.5, 0.5, 1, 1, @color)
  end
end

window = GameWindow.new
window.show
