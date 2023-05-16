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
      for(let col = 0; col< img.width; col +=10) {
        for(let row = 0; row<img.height; row +=10) {
          let c = img.get(col, row);
          p.fill(color(c));
          p.rect(col,row,10, 10);
          p.strokeWeight(0);
        }
      }
    }

    p.draw = function() {
      let xPos = p.round(random(0, img.width), -1);
      let yPos = p.round(random(0, img.height), -1);
      let c = img.get(xPos, yPos);
          c[0] += random(-20, 20);
          c[1] += random(-20, 20);
          c[2] += random(-20, 20);
          p.print(c);
          p.fill(color(c));
          p.rect(xPos,yPos,10, 10);
          p.strokeWeight(0);
    }
  }
  new p5(sketch, 'sketch-container');
};