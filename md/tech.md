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

The I tried to do the same by setting `a.currentTime` for the start,
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


