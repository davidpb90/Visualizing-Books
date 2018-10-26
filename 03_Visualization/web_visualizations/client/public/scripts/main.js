const _element = document.getElementById('container');
const elementWidth = _element.offsetWidth;
const elementHeight = _element.offsetHeight;

let visual = function (t) {
    'use strict';
    t.setup = function () {
        t.createCanvas(elementWidth, elementHeight);
        t.background(0);
    };
};

new p5(visual, 'container');