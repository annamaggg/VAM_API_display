function setup() {
  // const imageSrc = document.querySelector('script').getAttribute('data-image-src');
  const sketch = function(p) {
    let img;

    p.preload = function() {
      // img = p.loadImage(document.getElementById('original-image').src);
      img = p.loadImage(imageSrc);
    }

    p.setup = function() {
      p.createCanvas(img.width, img.height);
      p.print(img.width, img.height);
      for(let col = 0; col< img.width; col +=2) {
        for(let row = 0; row<img.height; row +=2) {
          let xPos = col;
          let yPos = row;
          let c = img.get(xPos, yPos);
          p.push();
          p.translate(xPos, yPos);
          p.rotate(radians(random(80)));
          p.noFill();
          c[0] -= 10
          p.stroke(color(c));
          p.print(c)
          p.strokeWeight(random(6,10));
          // p.point(xPos, yPos);
          p.strokeWeight(random(5));
          p.curve(xPos, yPos, p.sin(xPos) * p.random(60), cos(xPos) * sin(xPos) * random(90),
          random(10), random(80), cos(yPos) * sin(yPos) * random(140), cos(xPos) * sin(xPos) * 50);
          p.pop();
        }
      }
    };

    p.draw = function() {
          let xPos = random(0, img.width);
          let yPos = random(0, img.height);
          let c = img.get(xPos, yPos);
          p.push();
          p.translate(xPos, yPos);
          p.rotate(radians(random(80)));
          p.noFill();
          c[0] -= 10
          p.stroke(color(c));
          p.strokeWeight(random(3));
          p.point(xPos, yPos);
          p.strokeWeight(random(4));
          p.curve(xPos, yPos, p.sin(xPos) * p.random(20,60), cos(xPos) * sin(xPos) * random(20,90),
          random(10), random(80), cos(yPos) * sin(yPos) * random(40), cos(xPos) * sin(xPos) * 50);
          p.pop();
    }
  };

  new p5(sketch, 'sketch-container');
}