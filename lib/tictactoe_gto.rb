require "tictactoe_gto/version"

module TictactoeGto
  class Box

    attr_accessor :value

    def initialize(value)
      @value = value
    end

    def display
      print "| #{@value} |"
    end

    def is_empty?
      if @value == ' '
        return true
      else
        return false
      end
    end
  end

  class Board

    attr_reader :array
    attr_reader :size

    def initialize(size)
      @size = size
    end

    def fill
      @array = Array.new(@size) do
        Array.new(@size) { Box.new(' ') }
      end
    end

    def display
      print '   '
      @size.times { |i| print ' ' + i.to_s + '   ' }
      puts "\n"
      @array.each_with_index do |row, index|
        print index.to_s + ' '
        row.each { |box| box.display }
        print "\n"
      end
    end

    def fill_at(pos, id)
      box = @array[pos['x']][pos['y']]
      if box.is_empty?
        box.value = id
      else
        puts "> That spot is not available. Yo missed your chance :c"
      end
    end

    def self.get_size
      loop do
        print 'Ingresa el tamaño del tablero: '
        begin
          board_size = gets.chomp
          board_size = Integer(board_size)
        rescue
          print 'Are you sure it is a number? Please try again: '
          retry
        end
        if board_size < 2
          puts 'Board size must be 2X2 or higher, try again.'
        else
          puts 'Get ready!'
          return board_size
        end
      end
    end
  end

  class Player

    attr_accessor :id

    def initialize(id)
      @id = id
    end

    def customize?(id)
      print "Player #{id}: Would you like to customize your ID? (y/n): "
      loop do
        option = gets.chomp
        30.times { print '_ ' }
        print "\n"
        if option == 'y'
          puts 'Nice! Here we go!'
          return true
        elsif option == 'n'
          puts 'Nice! Old school!'
          return false
        else
          puts '*Confused* I did not understand your input, could you try again, please?'
          puts "HINT: 'y' is for: 'Hell yeah!' and 'n' is for: 'No, thanks. Maybe later'"
        end
        30.times { print '_ ' }
        print "\n"
      end
    end
  end

  class Game
    @winner

    def check_row(board, value)
      board.array.each do |row|
        if row.all? { |box| box.value == value }
          gameover_message value
          return true
        end
      end

      return false
    end

    def check_col(board, value)
      points = 0
      board.size.times do |index|
        board.array.each do |row|
          (row[index].is_empty? || row[index].value != value) ? points = 0 : points += 1
        end
        if points == board.size
          gameover_message value
          return true
        end
      end

      return false
    end

    def check_diagonal(board, value)
      indexD1 = 0
      indexD2 = board.size - 1
      pointsD1 = 0
      pointsD2 = 0
      board.array.each do |row|
        pointsD1 += 1 if row[indexD1].value == value
        pointsD2 += 1 if row[indexD2].value == value
        indexD1 += 1
        indexD2 -= 1
      end

      if pointsD1 == board.size || pointsD2 == board.size
        gameover_message value
        return true
      end

      return false
    end

    def over?(board, players)
      players.each_with_index do |player, index|
        if check_row(board, players[index].id) || check_col(board, players[index].id) || check_diagonal(board, players[index].id)
          @winner = players[index].id
          return true
        end
      end
      if draw?(board)
        @winner = nil
        return true
      end

      return false
    end

    def draw?(board)
      num = 0
      board.array.each do |row|
        row.each do |box|
          num += 1 if box.value == ' '
        end
      end

      if num == 0
        gameover_message ' '
        return true
      end

      return false
    end

    def move(board, player)
      puts "It's your turn Player #{player.id}!"
      coordinates = get_position(board)
      board.fill_at(coordinates, player.id)
      board.display

      return board
    end

    def get_position(board)
      coordinates = {x: 0, y: 0}
      loop do
        print 'Enter the number of the row: '
        begin
          coordinates['x'] = gets.chomp
          coordinates['x'] = Integer(coordinates['x'])
        rescue
          print 'Are you sure it is a number? Please try again: '
          retry
        end
        break if coordinates['x'] < board.size && coordinates['x'] >= 0
        puts 'That row is out of the board! Try again!'
      end
      loop do
        print 'Enter the number of the column: '
        begin
          coordinates['y'] = gets.chomp
          coordinates['y'] = Integer(coordinates['y'])
        rescue
          print 'Are you sure it is a number? Please try again: '
          retry
        end
        break if coordinates['y'] < board.size && coordinates['y'] >= 0
        puts 'That column is out of the board! Try again!'
      end

      coordinates
    end

    def play(players, board)
      players.reverse! unless @winner.nil?
      players.each do |player|
        board = move(board, player)
        if over?(board, players)
          return false
        end
      end

      return true
    end

    def play_again?
      loop do
        puts 'Nice moves out there!'
        print 'Would you like to play again (y/n): '
        option = gets.chomp
        30.times { print '_ ' }
        print "\n"
        if option == 'y'
          puts 'Yeah! Here we go! /.__./'
          return true
        elsif option == 'n'
          puts ':( We are sad that you are leaving us. Hope to see you soon!'
          return false
        else
          puts '*Confused* I did not understand your input, could you try again, please?'
          puts "HINT: 'y' is for: 'Hell yeah! Lets play again!' and 'n' is for: 'No, thanks. Maybe later'"
        end
        30.times { print '_ ' }
        print "\n"
      end
    end

    def gameover_message(value)
      50.times { print '-' }
      print "\n"
      if value == ' '
        puts 'DRAW GAME!'
        puts 'No winner this time.'
      else
        puts "Game over, Player #{value} wins."
      end
      50.times { print '-' }
      print "\n"
    end

    def customize_id(players)
      players.each_with_index do |player, index|
        if player.customize?(index + 1)
          puts "Player #{index + 1}: Enter any letter or symbol you want (just one): "
          id = gets.chomp
          puts 'I\'ll take just the first letter :D'if id.size > 1
          player.id = id[0]
        end
      end

      return players
    end

    def set_player1(players)
      case @last_player
      when players[0].id
        return players.reverse!
      when players[1].id
        return players
      end
    end

    private :check_col, :check_row, :check_diagonal, :gameover_message, :get_position
  end

  class Tictactoe
    def self.start
      puts '>>> Tic Tac Toe - Ruby version'
      puts '>> Powered by: @JJaimelr'
      puts '> Welcome'

      board_size = Board.get_size
      board = Board.new(board_size)
      players = [Player.new('X'), Player.new('O')]
      game = Game.new

      players = game.customize_id(players)
      board.fill
      board.display

      loop do
        if !game.play(players, board)
          break unless game.play_again?
          board_size = Board.get_size
          board = Board.new(board_size)
          players = game.set_player1 players
          players = game.customize_id players
          board.fill
          board.display
        end
      end
    end
  end
end
