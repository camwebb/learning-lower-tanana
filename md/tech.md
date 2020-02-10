% Tech issues

# Tech issues

## Playing segments of a sound file in HTML5

For anyone else wondering about this, here are some discoveries about
using the HTML5 `audio` element and built-in Javascript API. I’ve only
tried this using Firefox, so far.

The simplest way to play a clip of a sound is using the hypertext link format:

```html
<a href="soundfile.mp3#t=begintime,endtime"></a>
```
Timings are in seconds. The problem is that I could not find a way to
suppress the opening of the link in a new tab with the default media
player widget. So I needed to use a Javascript function. I went with
“virtual” audio elements (`<audio><source src="..."/></audio>`), so
that the file names were not hard coded into the page.

```javascript
function playSeg(file, begintime, endtime) {
  var a = document.createElement("audio");
  var s = document.createElement("source");
  a.appendChild(s);
  var r = document.createAttribute("src");
  r.value = "media/" + file + "#t=" + begintime + "," + endtime; 
  s.setAttributeNode(r);
  a.play();
}
```

I tried to do the same by setting `a.currentTime` for the start,
but found there is no simple way to `a.play()` for a fixed
duration. But the media’s `file#t=b,e` notation works.

Finally, linking to the sound clip in the page works best with 

```html
<a href="javascript:playSeg('file',b,e);">
```

Using 

```html
<a href="#" onclick="playSeg('file',b,e);">
```

scrolled the viewed page back to the page top on each link click.

## Sound file and timings

If the browser’s calculation of timings is off by just a few
milliseconds, or if a different source file is used, the sound clips
will not be correct and the work put into identifying the segments
will be wasted. To be sure you have the correct files, here are the
MD5SUMs:

```
68b2c8cb35b72402ff12e15278bca1bd  media/lt1a.mp3
b59a908dd1312ef353925aa829b28471  media/lt2a.mp3
be0a863786048de5d44a6dfed73f1d73  media/lt2b.mp3
```

## Webpage making

These HTML pages are generated using [Pandoc](https://pandoc.org/) on
Markdown. See the
[Github repo](https://github.com/camwebb/learning-lower-tanana) for
this project. Sound clips are written as `{file,start,end}` and a
simple `sed` script converts this to the appropriate HTML.

## Sound clips, Aha! 

I noticed that determining timings of segments in Audacity or elan and
using these timing in the method above did not work. As the timings
became longer the start times would be ‘off’. Also, the timings in
Firefox and Chromium were different. This led to a search for the
reason, and solution.

### Possible reason 1

Perhaps the `<audio>` playing method was not as good as the
comprehensive Web Audio API, which seems real ‘hi-fi’? I went down
this road quite a long way, struggling through examples, and new
Javascript constructs (‘arrow functions’).  I finally got sounds to
load. Here’s the minimal code (thanks to the many Web Audio API
tutorials on the web):

```javascript
const xhr = new XMLHttpRequest();
xhr.open("GET", "file1.mp3", true);
xhr.responseType = "arraybuffer";
xhr.onload = function() {
    const context = new (window.AudioContext || window.webkitAudioContext)();
    context.decodeAudioData(xhr.response, function(buffer) {
        const source = context.createBufferSource();
        source.buffer = buffer;
        source.connect(context.destination);
        source.start(0);
    });
};
xhr.send();
```

(I was also attracted to solving the challenge of delaying the
appearence of ‘play’ buttons or links until the (large) files had
loaded, after seeing
[this](https://github.com/mdn/webaudio-examples/blob/master/multi-track/),
but never quite solved the problem of passing audio buffer
identifiers to other functions... maybe one day.)

### Possible reason 2

As I was browsing, I came across this statement: “Due to browsers
protecting against fingerprinting and timing attacks, timing precision
under the hood can be reduced or rounded by modern browsers. This
would mean source.start(offset) could never be 100% accurate or
reliable in your case.” Oh dear. Perhaps the inaccuracy of seeking was
not a bug but a feature. One would have to switch off
`privacy.reduceTimerPrecision` in `about:config` for finding start
times in large files to work properly. That would suck, and open a
browser to attacks.  

In this case, finding sections in a large file would not be a good
solution, and cutting up a large file into little segment files would
be the best way (this would be easy with a script and something like
`ffmpeg -i in.mp3 -ss 3 -t 1 out.ogg`).

### Possible reason 3

Fortunately, I tried to do a seek in `mplayer` (`mplayer -ss 1307.07
media/lt1a.mp3`) and it failed. And I realized that “MP3 files are not
inherently seekable. They don't contain any timestamps.”
([source](https://stackoverflow.com/a/53747530/563709)). Duh - all
this trouble was due to using MP3 as the source. WAV files are too big
to share usefully, but the Ogg Vorbis format is similar in sizer to
MP3s and [has timestamps for seeking](https://xiph.org/ogg/).

Replacing the MP3s with OGG files, permits the simple `<audio>`
solution above to work, even across browsers and with long files.
