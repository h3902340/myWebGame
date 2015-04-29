<%@ Page Language="C#" AutoEventWireup="true" CodeFile="main.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>
<canvas id="ctx"  width="500" height="500" style="border: 1px solid #000000;"></canvas>

<script>
    var ctx = document.getElementById("ctx").getContext("2d");

    var HEIGHT = 500;
    var WIDTH = 500;
    var stage_num = 0;
    var score = 0;
    var player = {
        x: 225,
        y: 460,
        hp: 100,
        width: 100,
        height: 20,
        color: 'gold'
    };
    var ball = {
        r: 15,
        spdX: 6,
        spdY: -6,
        v: 6 * Math.sqrt(2),
        color: 'blue'
    };
    var brick = {
        width: 30,
        height: 20
    };
    var balllist = [];
    var bricklist = [];
    var stage = [
        // stage 1
        [
         [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
         [1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1],
         [1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1],
         [1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
         [1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0],
         [5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0],
         [6, 6, 6, 6, 6, 6, 6, 6, 6, 0, 0],
        ],
         // stage 2
         [
         [0, 1, 0, 0, 2, 2, 2, 0, 3, 3, 0],
         [1, 0, 1, 0, 2, 0, 0, 0, 3, 0, 3],
         [1, 1, 1, 0, 2, 2, 2, 0, 3, 3, 0],
         [1, 0, 1, 0, 0, 0, 2, 0, 3, 0, 0],
         [1, 0, 1, 0, 2, 2, 2, 0, 3, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 4, 0, 0, 4, 5, 5, 5, 6, 6, 6],
         [0, 4, 4, 0, 4, 5, 0, 0, 0, 6, 0],
         [0, 4, 0, 4, 4, 5, 5, 5, 0, 6, 0],
         [0, 4, 0, 0, 4, 5, 0, 0, 0, 6, 0],
         [6, 4, 0, 0, 4, 5, 5, 5, 0, 6, 0],
         ],
         // stage 3
         [
         [2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
         [2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
         [2, 0, 4, 3, 3, 3, 3, 3, 3, 0, 1],
         [2, 0, 4, 0, 0, 0, 0, 0, 3, 0, 1],
         [2, 0, 4, 0, 6, 5, 5, 0, 3, 0, 1],
         [2, 0, 4, 0, 6, 0, 5, 0, 3, 0, 1],
         [2, 0, 4, 0, 6, 0, 5, 0, 3, 0, 1],
         [2, 0, 4, 0, 0, 0, 5, 0, 3, 0, 1],
         [2, 0, 4, 4, 4, 4, 5, 0, 3, 0, 1],
         [2, 0, 0, 0, 0, 0, 0, 0, 3, 0, 1],
         [2, 2, 2, 2, 2, 2, 2, 2, 3, 0, 1]
         ]
    ];
    function hp_color(hp) {
        switch (hp) {
            case 1:
                return 'red';
                break;
            case 2:
                return 'orange';
                break;
            case 3:
                return 'yellow';
                break;
            case 4:
                return 'green';
                break;
            case 5:
                return 'blue';
                break;
            case 6:
                return 'purple';
                break;
        }
    }
    var create_stage = false;
    function draw_stage() {
        if (!create_stage) {
            create_stage = true;
            for (i = 0; i < stage[stage_num].length; i++) {
                for (j = 0; j < stage[stage_num][i].length; j++) {
                    if (stage[stage_num][i][j] != 0) {
                        var new_brick = {
                            x: 30 + 40 * j,
                            y: 25 + 30 * i,
                            width: brick.width,
                            height: brick.height,
                            hp: stage[stage_num][i][j],
                            drop: Math.floor(Math.random() * 9)
                        }
                        bricklist.push(new_brick);
                    }
                }
            }
            rand = getRandomSubarray(bricklist, bricklist.length * 0.5);
            for (i = 0; i < rand.length; i++) {
                rand[i].drop = 8;
            }
        }
        for (i = 0; i < bricklist.length; i++) {
            if (bricklist[i].hp != 0) {
                ctx.save();
                ctx.fillStyle = hp_color(bricklist[i].hp);
                ctx.fillRect(bricklist[i].x, bricklist[i].y, bricklist[i].width, bricklist[i].height);
                ctx.restore();
            }
        }
    }

    function getRandomSubarray(arr, size) {
        var shuffled = arr.slice(0), i = arr.length, temp, index;
        while (i--) {
            index = Math.floor((i + 1) * Math.random());
            temp = shuffled[index];
            shuffled[index] = shuffled[i];
            shuffled[i] = temp;
        }
        return shuffled.slice(0, size);
    }

    var droplist = [];
    function drop_item(brick) {
        switch (brick.drop) {
            case 0:
                var new_item = {
                    x: brick.x,
                    y: brick.y,
                    width: 40,
                    height: 20,
                    color: 'red',
                    text: "FAST"
                }
                droplist.push(new_item);
                break;
            case 1:
                var new_item = {
                    x: brick.x,
                    y: brick.y,
                    width: 40,
                    height: 20,
                    color: 'orange',
                    text: "slow"
                }
                droplist.push(new_item);
                break;
            case 2:
                var new_item = {
                    x: brick.x,
                    y: brick.y,
                    width: 40,
                    height: 20,
                    color: 'YellowGreen',
                    text: "BIG"
                }
                droplist.push(new_item);
                break;
            case 3:
                var new_item = {
                    x: brick.x,
                    y: brick.y,
                    width: 40,
                    height: 20,
                    color: 'green',
                    text: "small"
                }
                droplist.push(new_item);
                break;
            case 4:
                var new_item = {
                    x: brick.x,
                    y: brick.y,
                    width: 40,
                    height: 20,
                    color: 'blue',
                    text: "LONG"
                }
                droplist.push(new_item);
                break;
            case 5:
                var new_item = {
                    x: brick.x,
                    y: brick.y,
                    width: 40,
                    height: 20,
                    color: 'purple',
                    text: "short"
                }
                droplist.push(new_item);
                break;
            case 6:
                var new_item = {
                    x: brick.x,
                    y: brick.y,
                    width: 40,
                    height: 20,
                    color: 'DeepPink',
                    text: "hp"
                }
                droplist.push(new_item);
                break;
            case 7:
                var new_item = {
                    x: brick.x,
                    y: brick.y,
                    width: 40,
                    height: 20,
                    color: 'GoldenRod',
                    text: "coin"
                }
                droplist.push(new_item);
                break;
            case 8:
                break;
        }
    }

    window.addEventListener("click", function (e) {
        if (player.hp > 0) {
            add_ball();
            player.hp--;
            for (ball_index = 0; ball_index < balllist.length - 1; ball_index++) {
                for (other_ball_index = ball_index + 1; other_ball_index < balllist.length; other_ball_index++) {
                    balllist[ball_index].hit_ball.push(false);
                }
            }
            for (ball_index = 0; ball_index < balllist.length; ball_index++) {
                for (brick_index = 0; brick_index < bricklist.length; brick_index++) {
                    balllist[ball_index].hit_brick.push(false);
                }
            }
        }
    }, false);

    function add_ball() {
        var new_ball = {
            x: player.x,
            y: player.y - player.height * 0.5 - ball.r,
            r: ball.r,
            spdX: ball.spdX,
            spdY: ball.spdY,
            v: ball.v,
            color: ball.color,
            hit_rod: false,
            hit_wall: false,
            hit_ball: [],
            hit_brick: []
        }
        balllist.push(new_ball);
    }

    // the movement of the rod according to the mouse movement
    document.onmousemove = function (mouse) {

        if (mouse.clientX > WIDTH - player.width * 0.5) {
            player.x = WIDTH - player.width * 0.5
        }
        else if (mouse.clientX < player.width * 0.5) {
            player.x = player.width * 0.5;
        }
        else {
            player.x = mouse.clientX;
        }
    }

    function drawEntity(o) {
        ctx.save();
        ctx.fillStyle = o.color;
        ctx.fillRect(o.x - o.width / 2, o.y - o.height / 2, o.width, o.height);
        ctx.restore();
    }

    function updateEntityPosition(o, rect) {
        o.x += o.spdX;
        o.y += o.spdY;
        // hit the walls
        if (o.x < o.r && (!o.hit_wall || o.spdX < 0)) {
            o.spdX *= -1;
            o.hit_wall = true;
        }
        if (o.x > WIDTH - o.r && (!o.hit_wall || o.spdX > 0)) {
            o.spdX *= -1;
            o.hit_wall = true;
        }
        if (o.y < o.r && (!o.hit_wall || o.spdY < 0)) {
            o.spdY *= -1;
            o.hit_wall = true;
        }
        if (o.x > o.r && o.x < WIDTH - o.r && o.y > o.r && o.y < HEIGHT - o.r) {
            o.hit_wall = false;
        }

        // hit the top surface and the buttom of the rectangle
        if (o.x >= rect.x - rect.width * 0.5 && o.x <= rect.x + rect.width * 0.5
            && o.y >= rect.y - rect.height * 0.5 - o.r
            && rect.height * (o.x - rect.x) / rect.width >= o.y - rect.y && -rect.height * (o.x - rect.x) / rect.width >= o.y - rect.y) {
            if (o.spdY < 0) {
                o.y = rect.y - rect.height * 0.5 - o.r;
            }
            else {
                o.spdY *= -1;
            }
        }
        if (o.x >= rect.x - rect.width * 0.5 && o.x <= rect.x + rect.width * 0.5
            && o.y <= rect.y + rect.height * 0.5 + o.r
            && rect.height * (o.x - rect.x) / rect.width <= o.y - rect.y && -rect.height * (o.x - rect.x) / rect.width <= o.y - rect.y) {
            if (o.spdY > 0) {
                o.y = rect.y + rect.height * 0.5 + o.r;
            }
            else {
                o.spdY *= -1;
            }
        }
        //hit the sides of the rectangle
        if (o.y >= rect.y - rect.height * 0.5 && o.y <= rect.y + rect.height * 0.5 && o.x >= rect.x - rect.width * 0.5 - o.r
            && rect.height * (o.x - rect.x) / rect.width < o.y - rect.y && -rect.height * (o.x - rect.x) / rect.width > o.y - rect.y) {
            if (o.spdX < 0) {
                o.x = rect.x - rect.width * 0.5 - o.r;
            }
            else {
                o.spdX *= -1;
            }
        }
        if (o.y >= rect.y - rect.height * 0.5 && o.y <= rect.y + rect.height * 0.5 && o.x <= rect.x + rect.width * 0.5 + o.r
            && rect.height * (o.x - rect.x) / rect.width > o.y - rect.y && -rect.height * (o.x - rect.x) / rect.width < o.y - rect.y) {
            if (o.spdX > 0) {
                o.x = rect.x + rect.width * 0.5 + o.r;
            }
            else {
                o.spdX *= -1;
            }
        }
        // hit the four corners of the rectangle
        if (o.x < rect.x - rect.width * 0.5 && o.y < rect.y - rect.height * 0.5
            && Math.pow(rect.x - rect.width * 0.5 - o.x, 2) + Math.pow(rect.y - rect.height * 0.5 - o.y, 2) < Math.pow(o.r, 2) && !o.hit_rod) {
            dx = rect.x - rect.width * 0.5 - o.x;
            dy = rect.y - rect.height * 0.5 - o.y;
            o.spdX = -o.v * Math.cos(2 * Math.asin(dy / Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))) - Math.asin(o.spdY / Math.sqrt(Math.pow(o.spdX, 2) + Math.pow(o.spdY, 2))));
            o.spdY = -o.v * Math.sin(2 * Math.asin(dy / Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))) - Math.asin(o.spdY / Math.sqrt(Math.pow(o.spdX, 2) + Math.pow(o.spdY, 2))));
            o.spdX = o.v * (o.spdX / Math.sqrt(o.spdX * o.spdX + o.spdY * o.spdY));
            o.spdY = o.v * (o.spdY / Math.sqrt(o.spdX * o.spdX + o.spdY * o.spdY));
            o.hit_rod = true;
        }
        if (o.x > rect.x + rect.width * 0.5 && o.y < rect.y - rect.height * 0.5
            && Math.pow(rect.x + rect.width * 0.5 - o.x, 2) + Math.pow(rect.y - rect.height * 0.5 - o.y, 2) < Math.pow(o.r, 2) && !o.hit_rod) {
            dx = rect.x + rect.width * 0.5 - o.x;
            dy = rect.y - rect.height * 0.5 - o.y;
            o.spdX = -o.v * Math.cos(2 * Math.asin(dy / Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))) - Math.asin(o.spdY / Math.sqrt(Math.pow(o.spdX, 2) + Math.pow(o.spdY, 2))));
            o.spdY = -o.v * Math.sin(2 * Math.asin(dy / Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))) - Math.asin(o.spdY / Math.sqrt(Math.pow(o.spdX, 2) + Math.pow(o.spdY, 2))));
            o.spdX = o.v * (o.spdX / Math.sqrt(o.spdX * o.spdX + o.spdY * o.spdY));
            o.spdY = o.v * (o.spdY / Math.sqrt(o.spdX * o.spdX + o.spdY * o.spdY));
            o.hit_rod = true;
        }
        if (o.x < rect.x - rect.width * 0.5 && o.y > rect.y + rect.height * 0.5
            && Math.pow(rect.x - rect.width * 0.5 - o.x, 2) + Math.pow(rect.y + rect.height * 0.5 - o.y, 2) < Math.pow(o.r, 2) && !o.hit_rod) {
            dx = rect.x - rect.width * 0.5 - o.x;
            dy = rect.y + rect.height * 0.5 - o.y;
            o.spdX = -o.v * Math.cos(2 * Math.asin(dy / Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))) - Math.asin(o.spdY / Math.sqrt(Math.pow(o.spdX, 2) + Math.pow(o.spdY, 2))));
            o.spdY = -o.v * Math.sin(2 * Math.asin(dy / Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))) - Math.asin(o.spdY / Math.sqrt(Math.pow(o.spdX, 2) + Math.pow(o.spdY, 2))));
            o.spdX = o.v * (o.spdX / Math.sqrt(o.spdX * o.spdX + o.spdY * o.spdY));
            o.spdY = o.v * (o.spdY / Math.sqrt(o.spdX * o.spdX + o.spdY * o.spdY));
            o.hit_rod = true;
        }
        if (o.x < rect.x + rect.width * 0.5 && o.y > rect.y + rect.height * 0.5
            && Math.pow(rect.x + rect.width * 0.5 - o.x, 2) + Math.pow(rect.y + rect.height * 0.5 - o.y, 2) < Math.pow(o.r, 2) && !o.hit_rod) {
            dx = rect.x + rect.width * 0.5 - o.x;
            dy = rect.y + rect.height * 0.5 - o.y;
            o.spdX = -o.v * Math.cos(2 * Math.asin(dy / Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))) - Math.asin(o.spdY / Math.sqrt(Math.pow(o.spdX, 2) + Math.pow(o.spdY, 2))));
            o.spdY = -o.v * Math.sin(2 * Math.asin(dy / Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))) - Math.asin(o.spdY / Math.sqrt(Math.pow(o.spdX, 2) + Math.pow(o.spdY, 2))));
            o.spdX = o.v* (o.spdX / Math.sqrt(o.spdX * o.spdX + o.spdY * o.spdY));
            o.spdY = o.v * (o.spdY / Math.sqrt(o.spdX * o.spdX + o.spdY * o.spdY));
            o.hit_rod = true;
        }
        if (o.y < rect.y - rect.height * 0.5 - o.r || o.y > rect.y + rect.height * 0.5 + o.r
            || o.x < rect.x - rect.width * 0.5 - o.r || o.x > rect.x + rect.width * 0.5 + o.r) {
            o.hit_rod = false;
        }
    }

    function ball_hit_brick(o, rect) {
        // hit the top surface and the buttom of the rectangle
        if (o.x >= rect.x - rect.width * 0.5 && o.x <= rect.x + rect.width * 0.5
            && o.y >= rect.y - rect.height * 0.5 - o.r
            && rect.height * (o.x - rect.x) / rect.width >= o.y - rect.y && -rect.height * (o.x - rect.x) / rect.width >= o.y - rect.y) {
            rect.hp--;
            score++;
            if (o.spdY < 0) {
                o.y = rect.y - rect.height * 0.5 - o.r;
            }
            else {
                o.spdY *= -1;
            }
        }
        if (o.x >= rect.x - rect.width * 0.5 && o.x <= rect.x + rect.width * 0.5
            && o.y <= rect.y + rect.height * 0.5 + o.r
            && rect.height * (o.x - rect.x) / rect.width <= o.y - rect.y && -rect.height * (o.x - rect.x) / rect.width <= o.y - rect.y) {
            rect.hp--;
            score++;
            if (o.spdY > 0) {
                o.y = rect.y + rect.height * 0.5 + o.r;
            }
            else {
                o.spdY *= -1;
            }
        }
        //hit the sides of the rectangle
        if (o.y >= rect.y - rect.height * 0.5 && o.y <= rect.y + rect.height * 0.5 && o.x >= rect.x - rect.width * 0.5 - o.r
            && rect.height * (o.x - rect.x) / rect.width < o.y - rect.y && -rect.height * (o.x - rect.x) / rect.width > o.y - rect.y) {
            rect.hp--;
            score++;
            if (o.spdX < 0) {
                o.x = rect.x - rect.width * 0.5 - o.r;
            }
            else {
                o.spdX *= -1;
            }
        }
        if (o.y >= rect.y - rect.height * 0.5 && o.y <= rect.y + rect.height * 0.5 && o.x <= rect.x + rect.width * 0.5 + o.r
            && rect.height * (o.x - rect.x) / rect.width > o.y - rect.y && -rect.height * (o.x - rect.x) / rect.width < o.y - rect.y) {
            rect.hp--;
            score++;
            if (o.spdX > 0) {
                o.x = rect.x + rect.width * 0.5 + o.r;
            }
            else {
                o.spdX *= -1;
            }
        }
        // hit the four corners of the rectangle
        if (o.x < rect.x - rect.width * 0.5 && o.y < rect.y - rect.height * 0.5
            && Math.pow(rect.x - rect.width * 0.5 - o.x, 2) + Math.pow(rect.y - rect.height * 0.5 - o.y, 2) < Math.pow(o.r, 2) && !o.hit_brick[j]) {
            dx = rect.x - rect.width * 0.5 - o.x;
            dy = rect.y - rect.height * 0.5 - o.y;
            o.spdX = -o.v * Math.cos(2 * Math.asin(dy / Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))) - Math.asin(o.spdY / Math.sqrt(Math.pow(o.spdX, 2) + Math.pow(o.spdY, 2))));
            o.spdY = -o.v * Math.sin(2 * Math.asin(dy / Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))) - Math.asin(o.spdY / Math.sqrt(Math.pow(o.spdX, 2) + Math.pow(o.spdY, 2))));
            o.spdX = o.v * (o.spdX / Math.sqrt(o.spdX * o.spdX + o.spdY * o.spdY));
            o.spdY = o.v * (o.spdY / Math.sqrt(o.spdX * o.spdX + o.spdY * o.spdY));
            o.hit_brick[j] = true;
            rect.hp--;
            score++;
        }
        if (o.x > rect.x + rect.width * 0.5 && o.y < rect.y - rect.height * 0.5
            && Math.pow(rect.x + rect.width * 0.5 - o.x, 2) + Math.pow(rect.y - rect.height * 0.5 - o.y, 2) < Math.pow(o.r, 2) && !o.hit_brick[j]) {
            dx = rect.x + rect.width * 0.5 - o.x;
            dy = rect.y - rect.height * 0.5 - o.y;
            o.spdX = -o.v * Math.cos(2 * Math.asin(dy / Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))) - Math.asin(o.spdY / Math.sqrt(Math.pow(o.spdX, 2) + Math.pow(o.spdY, 2))));
            o.spdY = -o.v * Math.sin(2 * Math.asin(dy / Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))) - Math.asin(o.spdY / Math.sqrt(Math.pow(o.spdX, 2) + Math.pow(o.spdY, 2))));
            o.spdX = o.v * (o.spdX / Math.sqrt(o.spdX * o.spdX + o.spdY * o.spdY));
            o.spdY = o.v * (o.spdY / Math.sqrt(o.spdX * o.spdX + o.spdY * o.spdY));
            o.hit_brick[j] = true;
            rect.hp--;
            score++;
        }
        if (o.x < rect.x - rect.width * 0.5 && o.y > rect.y + rect.height * 0.5
            && Math.pow(rect.x - rect.width * 0.5 - o.x, 2) + Math.pow(rect.y + rect.height * 0.5 - o.y, 2) < Math.pow(o.r, 2) && !o.hit_brick[j]) {
            dx = rect.x - rect.width * 0.5 - o.x;
            dy = rect.y + rect.height * 0.5 - o.y;
            o.spdX = -o.v * Math.cos(2 * Math.asin(dy / Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))) - Math.asin(o.spdY / Math.sqrt(Math.pow(o.spdX, 2) + Math.pow(o.spdY, 2))));
            o.spdY = -o.v * Math.sin(2 * Math.asin(dy / Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))) - Math.asin(o.spdY / Math.sqrt(Math.pow(o.spdX, 2) + Math.pow(o.spdY, 2))));
            o.spdX = o.v * (o.spdX / Math.sqrt(o.spdX * o.spdX + o.spdY * o.spdY));
            o.spdY = o.v * (o.spdY / Math.sqrt(o.spdX * o.spdX + o.spdY * o.spdY));
            o.hit_brick[j] = true;
            rect.hp--;
            score++;
        }
        if (o.x < rect.x + rect.width * 0.5 && o.y > rect.y + rect.height * 0.5
            && Math.pow(rect.x + rect.width * 0.5 - o.x, 2) + Math.pow(rect.y + rect.height * 0.5 - o.y, 2) < Math.pow(o.r, 2) && !o.hit_brick[j]) {
            dx = rect.x + rect.width * 0.5 - o.x;
            dy = rect.y + rect.height * 0.5 - o.y;
            o.spdX = -o.v * Math.cos(2 * Math.asin(dy / Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))) - Math.asin(o.spdY / Math.sqrt(Math.pow(o.spdX, 2) + Math.pow(o.spdY, 2))));
            o.spdY = -o.v * Math.sin(2 * Math.asin(dy / Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))) - Math.asin(o.spdY / Math.sqrt(Math.pow(o.spdX, 2) + Math.pow(o.spdY, 2))));
            o.spdX = o.v * (o.spdX / Math.sqrt(o.spdX * o.spdX + o.spdY * o.spdY));
            o.spdY = o.v * (o.spdY / Math.sqrt(o.spdX * o.spdX + o.spdY * o.spdY));
            o.hit_brick[j] = true;
            rect.hp--;
            score++;
        }
        if (o.y < rect.y - rect.height * 0.5 - o.r || o.y > rect.y + rect.height * 0.5 + o.r
            || o.x < rect.x - rect.width * 0.5 - o.r || o.x > rect.x + rect.width * 0.5 + o.r) {
            o.hit_brick[j] = false;
        }
    }

    function ball_collision() {
        for (ball_index = 0; ball_index < balllist.length - 1; ball_index++) {
            for (other_ball_index = ball_index + 1; other_ball_index < balllist.length; other_ball_index++) {
                if (Math.pow(balllist[other_ball_index].x - balllist[ball_index].x, 2)
                    + Math.pow(balllist[other_ball_index].y - balllist[ball_index].y, 2) < Math.pow(balllist[ball_index].r + balllist[other_ball_index].r, 2)) {
                    if (!balllist[ball_index].hit_ball[other_ball_index]) {
                        balllist[other_ball_index].spdX = [balllist[ball_index].spdX, balllist[ball_index].spdX = balllist[other_ball_index].spdX][0];
                        balllist[other_ball_index].spdY = [balllist[ball_index].spdY, balllist[ball_index].spdY = balllist[other_ball_index].spdY][0];
                    }
                    balllist[other_ball_index].x = balllist[ball_index].x + (balllist[ball_index].r + balllist[other_ball_index].r) * (balllist[other_ball_index].x - balllist[ball_index].x) / Math.sqrt(Math.pow(balllist[other_ball_index].x - balllist[ball_index].x, 2) + Math.pow(balllist[other_ball_index].y - balllist[ball_index].y, 2));
                    balllist[other_ball_index].y = balllist[ball_index].y + (balllist[ball_index].r + balllist[other_ball_index].r) * (balllist[other_ball_index].y - balllist[ball_index].y) / Math.sqrt(Math.pow(balllist[other_ball_index].x - balllist[ball_index].x, 2) + Math.pow(balllist[other_ball_index].y - balllist[ball_index].y, 2));
                    balllist[ball_index].hit_ball[other_ball_index] = true;
                }
                else {
                    balllist[ball_index].hit_ball[other_ball_index] = false;
                }
            }
        }
    }

    function drawCircle(o) {
        ctx.save();
        ctx.fillStyle = o.color;
        ctx.beginPath();
        ctx.arc(o.x, o.y, o.r, 0, 2 * Math.PI);
        ctx.closePath();
        ctx.fill();
        ctx.restore();
    }
    function updateCircle(o, rect) {
        updateEntityPosition(o, rect);
        drawCircle(o);
    }

    function update() {
        ctx.clearRect(0, 0, WIDTH, HEIGHT);
        draw_stage();
        drawEntity(player);
        ctx.font = '30px Arial';
        ctx.fillStyle = 'black';
        ctx.fillText(player.hp + " Hp", 10, 490);
        ctx.fillText("Stage " + (stage_num + 1), 180, 490);
        ctx.fillText("Score: " + score, 350, 490);
        // dropping items
        for (ii = 0; ii < droplist.length; ii++) {
            ctx.font = '20px Arial';
            ctx.fillStyle = droplist[ii].color;
            ctx.fillText(droplist[ii].text, droplist[ii].x - droplist[ii].width * 0.5, droplist[ii].y - droplist[ii].height * 0.5);
            droplist[ii].y += 4;
            // eat the items
            if (droplist[ii].y > HEIGHT) {
                droplist.splice(ii, 1);
            }
            if (droplist[ii].x + droplist[ii].width * 0.5 > player.x - player.width * 0.5
                && droplist[ii].x - droplist[ii].width * 0.5 < player.x + player.width * 0.5
                && droplist[ii].y > player.y - player.height * 0.5 - droplist[ii].height * 0.5) {
                eat(droplist[ii]);
                score += 4;
                droplist.splice(ii, 1);
            }
        }

        ball_collision();
        for (i = 0; i < balllist.length; i++) {
            if (balllist[i].y > HEIGHT - balllist[i].r) {
                balllist.splice(i, 1);
            }
            updateCircle(balllist[i], player);
            for (j = 0; j < bricklist.length; j++) {
                ball_hit_brick(balllist[i], bricklist[j]);
            }
        }
        // brick dies
        for (j = 0; j < bricklist.length; j++) {
            if (bricklist[j].hp <= 0) {
                drop_item(bricklist[j]);
                bricklist.splice(j, 1);
                for (i = 0; i < balllist.length; i++) {
                    balllist[i].hit_brick.splice(j, 1);
                }
            }
        }
        if (bricklist.length == 0) {
            balllist = [];
            ball = {
                r: 15,
                spdX: 6,
                spdY: -6,
                v: 6 * Math.sqrt(2),
                color: 'blue'
            };
            player.width = 100;

            if (stage_num + 1 < stage.length) {
                alert("You have passed Stage" + (stage_num + 1) + ". Click confirm to go to the next Stage.");
                stage_num++;
                create_stage = false;
            }
            else {
                clearInterval(gameloop);
                alert("You have passed all the Stages in this game. Congratulation!\nEvery emaining life give you 10 bonus points.\nYour final score is " + (score + player.hp * 10) + ".\nPress F5 to play again.");
                ctx.font = '72px Arial';
                ctx.fillStyle = 'DarkGoldenRod';
                ctx.fillText("YOU WIN!", 70, 250);
            }
        }
        // player loses the game
        if(balllist.length == 0 && player.hp == 0)
        {
            clearInterval(gameloop);
            alert('Ypu lose the game. Press F5 to restart the game.');
        }
    }

    function eat(drop) {
        switch (drop.text) {
            case "FAST":
                for (i = 0; i < balllist.length; i++) {
                    balllist[i].spdX += 1;
                    balllist[i].spdY += 1;
                    balllist[i].v += Math.sqrt(2);
                }
                break;
            case "slow":
                
                for (i = 0; i < balllist.length; i++) {
                    if (balllist[i].v > 4) {
                        balllist[i].spdX -= 1;
                        balllist[i].spdY -= 1;
                        balllist[i].v -= Math.sqrt(2);
                    }
                }
                break;
            case "BIG":
                for (i = 0; i < balllist.length; i++) {
                    balllist[i].r += 5;
                }
                break;
            case "small":

                for (i = 0; i < balllist.length; i++) {
                    if (balllist[i].r > 5) {
                        balllist[i].r -= 5;
                    }
                }
                break;
            case "LONG":
                player.width += 30;
                break;
            case "short":
                if (player.width > 40) {
                    player.width -= 30;
                }
                break;
            case "hp":
                player.hp++;
                break;
            case "coin":
                score += 10;
                break;
        }
    }

    var gameloop = setInterval(update, 40);
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>My Web Game</title>
</head>
<body>
</body>
</html>
