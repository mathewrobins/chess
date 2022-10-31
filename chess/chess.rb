class Piece 
  attr_accessor :name, :color, :location, :movement, :symbol

  def initialize(name, color)
    @name = name
    @color = color
  end
end

class Chess
  attr_accessor :board, :empty_square

  
  def initialize
    @empty_square = String.new(" ")
    @board = Array.new(8) {Array.new(8, @empty_square)}
    @white_pieces = []
    @black_pieces = []
  end

  def play_game 
   
    create_pieces
    player_color = "white"
  
    loop do
      print_board(player_color)
      move = enter_move(player_color)
      piece = board[move[0][0]][ move[0][1]]
      #p piece
      end_location = move[1]
      #p end_location
      move_piece(piece, end_location)
      print_board(player_color)
      # break if player_color == "black"
      player_color == "white" ? player_color = "black" : player_color = "white"   
    end


  end


  def print_board(color)
    rows = (1..8).to_a.reverse
    columns = (1..8).to_a
    column_letters = ("a".."h").to_a

    if color == "black"
      rows = rows.reverse 
      columns = columns.reverse
      column_letters = column_letters.reverse
    end

    line = "  +---+---+---+---+---+---+---+---+"
    # separator = "| #{board[column][row]} "
    rows.each do |row|
      puts line
      print "#{row} "
      columns.each do |column|
        square = board[column-1][row-1]
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
    puts line
    print "    "
    column_letters.each do |letter|
      print "#{letter}   "
    end
    print "\n Captured Pieces: "
    # p @white_pieces
    # p @black_pieces
    @white_pieces.each { |piece| print piece.symbol}
    print "  "
    @black_pieces.each { |piece| print piece.symbol}
    puts
  end

  def create_pieces
    pieces = assign_piece_attributes(initialize_pieces)
    start_location(pieces)
  end


  def bishop_movement(player_color, origin_index, destination_index)
    row_start = origin_index[1]
    row_end = destination_index[1]
    column_start = origin_index[0]
    column_end = destination_index[0]
    vertical_distance = (row_end - row_start)
    horizontal_distance = (column_end - column_start)
    return false if vertical_distance.abs() != horizontal_distance.abs()
    vertical_distance > 0 ? vertical_direction = 1 :  vertical_direction = -1
    horizontal_distance > 0 ? horizontal_direction = 1 : horizontal_direction = -1
    i = column_start + vertical_direction
    j = row_start + horizontal_direction
    in_between_squares = []
    while i != column_end do
      p "[#{i}, #{j}] in between"
      in_between_squares.push(board[i][j])
      i += vertical_direction
      j += horizontal_direction
    end
    p in_between_squares
    return clear_path?(in_between_squares)
  end

  def rook_movement(player_color, origin_index, destination_index)
    row_start = origin_index[1]
    row_end = destination_index[1]
    column_start = origin_index[0]
    column_end = destination_index[0]
    direction = 1
    vertical_distance = (row_end - row_start)
    horizontal_distance = (column_end - column_start)
    direction = -1 if horizontal_distance < 0 || vertical_distance < 0
    in_between_squares = []
    if vertical_distance.zero? || horizontal_distance.zero?
      if vertical_distance.zero?
        i = column_start + direction
        while i != column_end do
          in_between_squares.push(board[i][row_start])
          i += direction 
        end
      else
        i = row_start + direction
        while i != row_end
          in_between_squares.push(board[column_start][i])
          i += direction
        end
      end
      p in_between_squares
      return clear_path?(in_between_squares)
    end
    false
  end

  def clear_path?(squares)
    squares.each do |square|
      p square
      return false if square.is_a?(Piece)
    end
    true
  end

  def orthogonal(start_postion, stop_position)
    line = Array.new(start_position..stop_position)   

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
        piece.movement = ["orthogonal"]
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
        piece.movement = ["orthogonal", diagonal]
      end
    end
  end  
  
  # def pawn_movement(piece, end_location)
  #   start = piece.location
  #   offset = end_location[0] - start[0]
  #   distance = end_location[1] - start[1]
  #   distance = -distance if piece.color == "black" 
  #   p distance
  #   p offset
  #   distance == 1 ? true : false
    
  # end

  def pawn_movement(player_color, origin_index, destination_index)
    destination = board[destination_index[0]][destination_index[1]]
    distance = destination_index[1] - origin_index[1]
    offset = (destination_index[0] - origin_index[0]).abs()
    distance = -distance if player_color == "black"
    p distance
    p offset

    if offset == 1 && distance == 1 
      if destination.is_a?(Piece) && destination.color != player_color
        return true
      end
      return false
    end

    if offset == 0
      if distance == 2
        return true if player_color == "white" && origin_index[1] == 1
        return true if player_color == "black" && origin_index[1] == 6
        return false
      end
      if distance == 1
        if destination.is_a?(Piece)
          puts "There is a piece in the way"
          return false
        end
        if destination_index[1] == 7 && player_color == "white" || destination_index[1] =0 && player_color == "black"
          pawn_promotion
          return true
        end
        return true
      end
    end
    puts "That is not a legal move"
    false
  end

  def pawn_promotion
    puts "You can now promote the pawn"
  end


 

  def enter_move(player_color)
    requested_move = []
    loop do
      piece_name = input_start_piece
      # start_square = input_move("first")
      start_square = input_origin_square(player_color)
      start_square_index = convert_to_index(start_square)
      end_square = input_destination_square
      end_square_index = convert_to_index(end_square)
      requested_move = [start_square_index, end_square_index]
      break if legal_move?(start_square, end_square)    
      print_board(player_color)
      puts "That is not a legal move.  Try again"
    end
    # record_move(requested_move)
    requested_move
  end

  def record_move(requested_move)
    letter = get_piece_letter(requested_move[0])

  end

  def get_piece_letter(piece_location)
    piece_name = board[piece_location[0]][piece_location[1]].name
    case piece_name
    when "pawn"
      return ""
    when "rook"
      return "R"
    when "bishop"
      return "B"
    when "knight"
      return "N"
    when "queen"
      return "Q"
    when "king"
      return "K"
    end
  end

  def same_team?(player_color, destination_index)
    other_square = board[destination_index[0]][destination_index[1]]
    return false if !other_square.is_a?(Piece)
    return false if other_square.color != player_color
    true
  end


  def legal_move?(origin_square, destination_square)
    puts "legal move?"
    origin_index = convert_to_index(origin_square)
    destination_index = convert_to_index(destination_square)
    piece = board[origin_index[0]][origin_index[1]]
    player_color = piece.color
    piece_name = piece.name
    return false if same_team?(player_color, destination_index)
    case piece_name
    when "pawn" 
      p "checking pawn-movement"
      return pawn_movement(player_color, origin_index, destination_index)
    when "rook" 
      return rook_movement(player_color, origin_index, destination_index)
    when "knight" 
      return knight_movement(player_color, origin_index, destination_index)
    when "bishop" 
      return bishop_movement(player_color, origin_index, destination_index)
    when "queen" 
      return queen_movement(player_color, origin_index, destination_index)
    when "king" 
      return king_movement(player_color, origin_index, destination_index)
    end
  end

  def input_start_piece 
    piece_name = " "
    loop do
      
      puts "R = rook, B = bishop, N = knight, Q = Qeen, K = king, P = pawn"
      print "What piece would you like to move?"
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

  def players_piece?(square,player_color)
    square_index = convert_to_index(square)
    piece = board[square_index[0]][square_index[1]]
    if piece.color != player_color
      puts "This is not your piece"
      return false
    end
    true
  end

  def on_board?(square)
    if square.nil?
      puts "Invalid Entry"
      return false
    end
    true
  end

  def empty_square?(square)
    square_index = convert_to_index(square)
    return true if board[square_index[0]][square_index[1]] == @empty_square
    false 
  end

  def input_origin_square(player_color) 
    square = []
    loop do
      loop do 
        querry_move("origin")
        square = input_square
        break if !on_board?(square)
        if empty_square?(square)
          puts "There is not a piece on that square"
          break
        end
        break if !players_piece?(square, player_color)
        return square
      end
    end
  end

  def input_destination_square
    square = []
    loop do
      querry_move("destination")
      square = input_square
      break if on_board?(square)
    end
    square
  end


  # def input_move(first_or_next)
  #   square = []
  #   loop do
  #     loop do 
  #       querry_move(first_or_next)
  #       square = input_square
      

  #       break if square != nil 

  #     end
  #     break if players_piece?(square,color)
  #   end
  #   square
  # end

  def querry_move(origin_or_destination)
    origin_or_destination == "origin" ? querry_start_square : querry_next_square
  end

  def querry_start_square
    print "What square is it on? "
  end

  def querry_next_square
    print "Where do you want to move?"
  end

  def input_square
      square =  gets.chomp.downcase
      if square.size == 2 
        return square if square[0].match?(/[A-H]/i) && square[1].match?(/[1-8]/) 
      end
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

  def captured(piece)
    puts "Captured piece #{piece}"
    piece.color == "white" ? @white_pieces.push(piece) : @black_pieces.push(piece)
  end


  def move_piece(piece, end_location)
    start = piece.location
    next_position = board[end_location[0]][end_location[1]]
    board[start[0]][start[1]] = @empty_square
    captured(next_position)if next_position.is_a?(Piece)
    piece.location = end_location
    board[end_location[0]][end_location[1]] = piece     
  end
end

game = Chess.new
game.play_game
# game.create_pieces
# game.print_board("black")



# game.enter_move










