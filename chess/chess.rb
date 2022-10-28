class Piece 
  attr_accessor :name, :color, :location, :movement, :symbol

  def initialize(name, color)
    @name = name
    @color = color
  end
end

class Chess
  attr_accessor :board

  @empty_square = " "
  def initialize
    @board = Array.new(8) {Array.new(8, @empty_square)}
    @white_pieces = []
    @black_pieces = []
  end

  def print_board(board)
    line = "+---+---+---+---+---+---+---+---+"
    # separator = "| #{board[column][row]} "
    8.times do |row|
      puts line
      8.times do |column|
        square = board[column][row]
        if square.is_a? Piece
          separator1 = "| #{square.symbol} "
      
          print separator1
        else
          separator2 = "|   "
          print separator2
        end

        
      end
      puts "|"
    end
  end

  def create_pieces
    pieces = assign_piece_attributes(initialize_pieces)
    start_location(pieces)
  end

  def orthogonal
  end

  def diagonal
  end

  def all_directions
  end

  def knight_movement
  end


  def initialize_pieces
    white_pieces = []
    black_pieces = []
    pieces = []
    white_pieces[0] = Piece.new("rook", "white")
    white_pieces[1] = Piece.new("bishop", "white")
    white_pieces[2] = Piece.new("knight", "white")
    white_pieces[3] = Piece.new("king", "white")
    white_pieces[4] = Piece.new("queen", "white")
    white_pieces[5] = Piece.new("knight", "white")
    white_pieces[6] = Piece.new("bishop", "white")
    white_pieces[7] = Piece.new("rook", "white")
    8.times do |i|
      white_pieces[i+8] = Piece.new("pawn", "white")
    end
    white_pieces.reverse_each do |piece| 
      black_pieces.push(Piece.new(piece.name, "black"))
    end
    pieces = white_pieces.concat(black_pieces)

    # pieces.each do |piece|
    #   puts piece.name + " #{piece.color}"
    # end

  end

  def start_location(pieces)
    i = 0
    4.times do |row|
      8.times do |column|
        location = Array.new()
        row < 2 ? row_board = row : row_board = row + 4 
        pieces[i].location = [column,row_board]
        board[column][row_board] = pieces[i]
        #. puts pieces[i].name + " #{pieces[i].location}"
        i += 1
      end
    end
  end

  def assign_symbols(piece, white_symbol, black_symbol)
    piece.color == "white" ? piece.symbol = white_symbol : piece.symbol = black_symbol 
  end



  def assign_piece_attributes(pieces)
    pieces.each do |piece|
      case piece.name
      when "pawn"
        assign_symbols(piece, "\u2659" , "\u265f")
        piece.movement = ["pawn_movement"]
      when "rook"
        assign_symbols(piece, "\u2656" , "\u265c")
        piece.movement = [orthogonal]
      when "bishop" 
        assign_symbols(piece, "\u2657" , "\u265d")
        piece.movement = [diagonal]
      when "knight"
        assign_symbols(piece, "\u2658" , "\u265e")
        piece_movement = [knight_movement]
      when "king"
        assign_symbols(piece, "\u2654" , "\u265a")
        piece.movement = [all_directions]
      when "queen"
        assign_symbols(piece, "\u2655" , "\u265b")
        piece.movement = [orthogonal, diagonal]
      end
    end
  end  
  
  def pawn_movement(piece, end_location)
    start = piece.location
    offset = end_location[0] - start[0]
    distance = end_location[1] - start[1]
    distance = -distance if piece.color == "black" 
    p distance
    p offset
    distance == 1 ? true : false
    
  end

 

  def enter_move
    piece_name = input_start_piece
    input_move("first")
    input_move("second")
  end


  def legal_move?(piece, start_square, move_square)
    true
  end

  def input_start_piece 
    piece_name = " "
    loop do
      
      puts "R = rook, B = bishop, N = knight, Q = Qeen, K = king, P = pawn"
      puts "What piece would you like to move?"
      piece = gets.chomp.upcase
      case piece
      when "R"
        piece_name = "rook"
      when "B"
        piece_name = "bishop"
      when "N"
        piece_name = "knight"
      when "Q"
        piece_name = "queen"
      when "K"
        piece_name = "king"
      when "P"
        piece_name = "pawn"
      end
      break if piece_name != " "
      puts "#{piece} is not a valid input"
    end
    piece_name


  end

  def input_move(first_or_next)
    square = []
    loop do
      querry_move(first_or_next)
      square = input_square
      break if square != nil
    end
    square
  end

  def querry_move(first_or_next)
    first_or_next == "first" ? querry_start_square : querry_next_square
  end

  def querry_start_square
    puts "\n What square is it on? "
  end

  def querry_next_square
    puts "Where do you want to move?"
  end

  def input_square
      square =  gets.chomp.downcase
      return square if square[0].match?(/[A-F]/i) && square[1].match?(/[1-8]/) 
      puts "#{square} is not a square on the board.  Try again. \n"
      square = nil
  end



  def convert_to_index(chess_notation)
    column_reference = { "a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6, "h" => 7}
    column = column_reference[chess_notation[0]]
    row = chess_notation[1].to_i - 1
    position = [column, row]
  end


  def remove_piece(piece)
    piece.location = []
  end

  def move_piece(piece, end_location)
    start = piece.location
    next_position = board[end_location[0]][end_location[1]]
    board[start[0]][start[1]] = @empty_square
    if next_position == @empty_square
      piece.location = end_location
      board[end_location[0]][end_location[1]] = piece     
    end
  end
end

game = Chess.new
game.create_pieces



game.enter_move










