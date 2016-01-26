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

def new_food(food, snake, dimensions)
  x_spaces = (0..dimensions[:width] - 1).to_a
  y_spaces = (0..dimensions[:height] - 1).to_a
  all_spaces = x_spaces.product y_spaces
  taken_spaces = food + snake

  all_spaces.shuffle.find { |space| !taken_spaces.include? space }
end


def obstacle_ahead?(snake, direction, dimensions)
  next_head = move_segment(snake[-1], direction)

  within_x = next_head[0] >= 0 && next_head[0] < dimensions[:width]
  within_y = next_head[1] >= 0 && next_head[1] < dimensions[:height]

  !within_x || !within_y || (snake.include? next_head)
end

def danger?(snake, direction, dimensions)
  obstacle_ahead?(snake, direction, dimensions) ||
    obstacle_ahead?(move(snake, direction), direction, dimensions)
end
