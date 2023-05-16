function setup() {
  const sketch = function(p) {
    let img;

    p.preload = function() {
      // img = p.loadImage(document.getElementById('original-image').src);
      img = p.loadImage('/anna.jpeg');
    }

    p.setup = function() {
      p.createCanvas(img.width, img.height);
      p.print(img.width, img.height);
    };

    p.draw = function() {
      for(let col = 0; col< img.width; col +=2) {
        for(let row = 0; row<img.height; row +=2) {
          let xPos = col;
          let yPos = row;
          let c = img.get(xPos, yPos);
          p.push();
          p.translate(xPos, yPos);
          p.rotate(radians(random(360)));
          p.noFill();
          c[0] -= 10
          p.stroke(color(c));
          p.print(c)
          p.strokeWeight(random(6,10));
          // p.point(xPos, yPos);
          p.strokeWeight(random(10));
          p.curve(xPos, yPos, p.sin(xPos) * p.random(20,60), cos(xPos) * sin(xPos) * random(20,90),
          random(10), random(80), cos(yPos) * sin(yPos) * random(140), cos(xPos) * sin(xPos) * 50);
          p.pop();
        }
      }
    }
  }
}