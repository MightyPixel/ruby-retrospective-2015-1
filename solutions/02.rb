def move_segment(segment, direction)
  [segment[0] + direction[0], segment[1] + direction[1]]
end

def move(snake, direction)
  head = snake[-1]

  snake[1..-1].push move_segment(head, direction)
end

def grow(snake, direction)
  head = snake[-1]

  snake[0..-1].push move_segment(head, direction)
end

def inside?(point, rectangle)
  within_x = point[0].between?(0, rectangle[:width] - 1)
  within_y = point[1].between?(0, rectangle[:height] - 1)

  within_x && within_y
end

def new_food(food, snake, dimensions)
  x_spaces = (0...dimensions[:width]).to_a
  y_spaces = (0...dimensions[:height]).to_a

  all_spaces = x_spaces.product y_spaces
  taken_spaces = food + snake

  (all_spaces - taken_spaces).sample
end


def obstacle_ahead?(snake, direction, dimensions)
  next_head = move_segment(snake[-1], direction)

  !inside?(next_head, dimensions) || (snake.include? next_head)
end

def danger?(snake, direction, dimensions)
  obstacle_ahead?(snake, direction, dimensions) ||
    obstacle_ahead?(move(snake, direction), direction, dimensions)
end
