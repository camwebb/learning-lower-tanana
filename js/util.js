function playSeg(file, begintime, endtime) {
    var a = document.createElement("audio");
    var s = document.createElement("source");
    a.appendChild(s);
    var r = document.createAttribute("src");
    r.value = "media/" + file + ".ogg#t=" + begintime + "," + endtime; 
    s.setAttributeNode(r); 
    a.play();
}
