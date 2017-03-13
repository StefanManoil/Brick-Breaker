Ball ball;
Brick [] bricks;
Paddle paddle;

int lives = 5;

//this method runs once, when you load the sketch
void setup()
{
    size(400, 400);
    frameRate(60);

    ellipseMode(CORNER);

    ball = new Ball();
    ball.x = 100;
    ball.y = 100;
    ball.width = 20;
    ball.height = 20;
    ball.xSpeed = 4;
    ball.ySpeed = 3;
    ball.clr = color (120, 200, 35);

    bricks = new Brick[8];
    for (int i=0; i<bricks.length; i++)
    {
        bricks[i] = new Brick();
        bricks[i].width = 50;
        bricks[i].height = 20;
        bricks[i].x = i * bricks[i].width;
        bricks[i].y = 30;
        bricks[i].clr = color (random(255), random(255), random(255));
    }

    paddle = new Paddle ();
    paddle.width = 100;
    paddle.height = 20;
    paddle.x = width/2 - paddle.width/2;
    paddle.y = height - 60;
    paddle.xSpeed = 0;
    paddle.clr = color (255, 0, 0);
}

//this method calls itself after waiting however long your frame rate is
void draw()
{
    moveBall();
    movePaddle();

    collisionBallWall();
    collisionPaddleWall();
    collisionBallBrick();
    collisionBallPaddle();
    collisionBallBottom();

    drawScreen();
}

void drawScreen()
{
    //clear the background
    background(0);

    //draw the bricks
    for (int i=0; i<bricks.length; i++)
    {
        fill(bricks[i].clr);
        rect(bricks[i].x, bricks[i].y, bricks[i].width, bricks[i].height);
    }

    //draw the paddle
    fill(paddle.clr);
    rect(paddle.x, paddle.y, paddle.width, paddle.height);

    //draw the ball
    fill(ball.clr);
    ellipse(ball.x, ball.y, ball.width, ball.height);

    //draw lives
    fill(255);
    textSize(20);
    text("Lives: " + lives, 0, height - 10);
}

void keyPressed()
{
    if (keyCode == 37)
        paddle.xSpeed = -5;
    else if (keyCode == 39)
        paddle.xSpeed = 5;
}

void keyReleased()
{
    if (keyCode == 37)
        paddle.xSpeed = 0;
    else if (keyCode == 39)
        paddle.xSpeed = 0;
}

void moveBall()
{
    ball.x += ball.xSpeed;
    ball.y += ball.ySpeed;
}

void movePaddle()
{
    paddle.x += paddle.xSpeed;
}


void collisionBallWall()
{
    if (ball.x <= 0)
        ball.xSpeed *= -1;
    else if (ball.x + ball.width >= width)
        ball.xSpeed *= -1;
    if (ball.y <= 0)
        ball.ySpeed *= -1;
    else if (ball.y + ball.height >= height)
        ball.ySpeed *= -1;
}

void collisionPaddleWall()
{
    if (paddle.x <= 0)
    {
        paddle.xSpeed = 0;
        paddle.x = 0;
    }
    else if (paddle.x + paddle.width >= width)
    {
        paddle.xSpeed = 0;
        paddle.x = width - paddle.width;
    }
}


void collisionBallBrick()
{
    for (int i=0; i < bricks.length; i++)
    {
        if (bricks[i].clr != color(0))
        {
            if (ball.intersects(bricks[i]))
            {
                bricks[i].clr = color(0);

                float collisionBottom = ball.y + ball.height - bricks[i].y;
                float collisionTop = bricks[i].y + bricks[i].height - ball.y;
                float collisionLeft = bricks[i].x + bricks[i].width - ball.x;
                float collisionRight = ball.x + ball.width - bricks[i].x;

                if (collisionBottom <= collisionTop && collisionBottom <= collisionLeft && collisionBottom <= collisionRight)
                {
                    ball.ySpeed *=-1;
                    ball.y = bricks[i].y - ball.height;
                }
                else if (collisionTop <= collisionBottom && collisionTop <= collisionLeft && collisionTop <= collisionRight)
                {
                    ball.ySpeed *=-1;
                    ball.y = bricks[i].y + bricks[i].height;
                }
                else if (collisionLeft <= collisionBottom && collisionLeft <= collisionTop && collisionLeft <= collisionRight)
                {
                    ball.xSpeed *=-1;
                    ball.x = bricks[i].x + bricks[i].width;
                }
                else if (collisionRight <= collisionBottom && collisionRight <= collisionTop && collisionRight <= collisionLeft)
                {
                    ball.xSpeed *=-1;
                    ball.x = bricks[i].x - ball.width;
                }
            }
        }
    }
}

void collisionBallPaddle()
{
    if (ball.intersects(paddle))
    {
        float collisionBottom = ball.y + ball.height - paddle.y;
        float collisionTop = paddle.y + paddle.height - ball.y;
        float collisionLeft = paddle.x + paddle.width - ball.x;
        float collisionRight = ball.x + ball.width - paddle.x;

        if (collisionBottom <= collisionTop && collisionBottom <= collisionLeft && collisionBottom <= collisionRight)
        {
            ball.ySpeed *=-1;
            ball.y = paddle.y - ball.height;
        }
        else if (collisionTop <= collisionBottom && collisionTop <= collisionLeft && collisionTop <= collisionRight)
        {
            ball.ySpeed *=-1;
            ball.y = paddle.y + paddle.height;
        }
        else if (collisionLeft <= collisionBottom && collisionLeft <= collisionTop && collisionLeft <= collisionRight)
        {
            ball.xSpeed *=-1;
            ball.x = paddle.x + paddle.width;
        }
        else if (collisionRight <= collisionBottom && collisionRight <= collisionTop && collisionRight <= collisionLeft)
        {
            ball.xSpeed *=-1;
            ball.x = paddle.x - ball.width;
        }
    }
}

void collisionBallBottom()
{
    if (ball.y + ball.height >= height)
    {
        lives --;
        ball.x = width/2;
        ball.y = width/2;

        if (lives == 0)
        {
            ball.xSpeed = 0;
            ball.ySpeed = 0;
        }
    }
}

class Rectangle
{
    float x, y, width, height;

    boolean intersects (Rectangle other)
    {
        return (x < other.x + other.width) && (y < other.y + other.height) && (x + width > other.x) && (y + height > other.y);
    }
}

class Ball extends Rectangle
{
    float xSpeed, ySpeed;
    color clr;
}

class Brick extends Rectangle
{
    color clr;
}

class Paddle extends Rectangle
{
    float xSpeed;
    color clr;
}

