/*
    This file is part of Magnum.

    Copyright © 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018
              Vladimír Vondruš <mosra@centrum.cz>

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
    THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
    DEALINGS IN THE SOFTWARE.
*/

layout(std140) uniform Style {
    lowp vec4 borderWidthCornerRadiusSmoothnessInOut;
    lowp vec4 colors[FOREGROUND_COLOR_COUNT*3];
};

#define cornerRadius borderWidthCornerRadiusSmoothnessInOut.y

uniform mediump mat4 transformationProjectionMatrix;

layout(location = 0) in mediump vec2 vertexPosition;
layout(location = 1) in mediump vec4 edgeDistance;
layout(location = 2) in mediump vec4 rect;
layout(location = 3) in mediump int colorIndex;

out mediump vec4 fragmentEdgeDistance;
flat out mediump int fragmentColorIndex;
out mediump vec4 fragmentCornerCoordinates;

void main() {
    fragmentEdgeDistance = edgeDistance;
    fragmentColorIndex = colorIndex;

    mediump vec2 rectSize = rect.zw - rect.xy;

    fragmentCornerCoordinates.xy = mix(vec2(-(rectSize.x - cornerRadius)/(2.0*cornerRadius)),
        vec2(0.5), edgeDistance.xy);
    fragmentCornerCoordinates.wz = mix(vec2(-(rectSize.y - cornerRadius)/(2.0*cornerRadius)),
        vec2(0.5), edgeDistance.wz);

    mediump vec2 position = rect.xy + vertexPosition*rectSize;

    gl_Position = transformationProjectionMatrix*vec4(position, 0.0, 1.0);
}
