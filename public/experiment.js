function setup() {
  const sketch = function(p) {
    let img;

    p.preload = function() {
      img = p.loadImage('/anna.jpeg');
    }

    p.setup = function() {
      p.createCanvas(img.width, img.height);
      p.print(img.width, img.height);
      let offset = 2;
      let d = 3;
      for(let i = 0; i< img.width; i +=2) {
        for(let j = 0; j<img.height; j +=2) {
          let x = offset + i * (d);
          let y = offset + j * (d);

            p.drawLineByPoint(x, y, x + d, y + d);

        }
      }
    };

    p.drawLineByPoint = function(x1, y1, x2, y2) {
      let distance = dist(x1, y1, x2, y2);
      let angle = atan2(y2 - y1, x2 - x1);
      push();
      translate(x1, y1);
      rotate(angle);
      scale(1, random() > 0.5 ? -1 : 1);
      let d = 0;
      while (d < 1) {
        let px = lerp(x1, x2, d);
        let py = lerp(y1, y2, d);
        let n = sq(noise(d, px / 150, py / 150));
        strokeWeight((n * distance) / 2);
        stroke(0, 0, 0, n * 50);
        push();
        translate(d * distance, ((n - 1 / 2) * distance) / random(20));
        rotate(random(360));
        shearX(random(30)*(random()>0.5?-1:1));
        shearY(random(30)*(random()>0.5?-1:1));
        point(0,0);
        pop();
      }
    };
  }
  new p5(sketch, 'sketch-container');
};