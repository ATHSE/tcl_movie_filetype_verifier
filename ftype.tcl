# Movie Filetype Verifier 1.0000003F (c) 2021
#
# MIT License:
#
# Permission is hereby granted, free of charge, to any person obtaining a copy 
# of this software and associated documentation files (the “Software”), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# #
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
proc logwrite {} {
	global eros
	catch {open "ftype.log" w} fid
	if [string match "file*" $fid] {
		puts $fid "\[[clock format [clock seconds] -format "%a,%b,%Y - %H:%M:%S"] - Beginning FileType Scan\]"
		if ![info exists eros] {
			puts $fid "> No invalid file signatures found."
		} else {
			puts "> Saving ftype.log"
			foreach ero $eros {puts $fid $ero}
		}
	} else {
		puts "> Error saving ftype.log"
	}
	close $fid
}	

proc mov {} {
	global eros
	set maintypes "ftyp mdat moov pnot udta uuid moof free skip {jP2 } wide load ctab imap matt kmat clip crgn sync chap tmcd scpt ssrc PICT"
	set subtypes "{qt  } avc1 iso2 isom mmp4 mp41 mp42 mp71 msnv ndas ndsc ndsh ndsm ndsp ndss ndxc ndxh ndxm ndxp ndxs"
	if ![catch {glob *.mov} files] {
	foreach filed $files {
		set errcnt 0
		if ![file isfile $filed] {continue}
		catch {open $filed r} of
		if {![file readable $filed] || ![string match "file*" $of]} {puts "$filed is not readable ..." ; continue}
		fconfigure $of -translation binary
		binary scan [read $of 4] c chunk 
		binary scan [read $of 4] a* tname
		binary scan [read $of 4] a* sname
		set dmsg ""
		if {[lsearch $maintypes $tname] == -1} {
			append dmsg "\[*inv*\] "
			incr errcnt
		} else {
			append dmsg "\[valid\] "
		}
		if {[lsearch $subtypes $sname] == -1} {
			append dmsg "\[*inv*\] "
			incr errcnt
		} else {
			append dmsg "\[valid\] "
		}
		append dmsg $filed
		puts $dmsg
		if {$errcnt > 0} {lappend eros $dmsg}
	}
	}
}
	
proc mp4 {} {
	global eros
	set maintypes "ftyp udta uuid {jP2 } load ctab imap matt kmat clip crgn sync chap tmcd scpt ssrc"  ;# mdat moov pnot wide moof free skip
	set subtypes "{M4V } avc1 iso2 isom mmp4 mp41 mp42 mp71 msnv ndas ndsc ndsh ndsm ndsp ndss ndxc ndxh ndxm ndxp ndxs"
	if ![catch {glob *.mp4} files] {
	foreach filed $files {
		set errcnt 0
		if ![file isfile $filed] {continue}
		catch {open $filed r} of
		if {![file readable $filed] || ![string match "file*" $of]} {puts "$filed is not readable ..." ; continue}
		fconfigure $of -translation binary
		binary scan [read $of 4] c chunk 
		binary scan [read $of 4] a* tname
		binary scan [read $of 4] a* sname
		set dmsg ""
		if {[lsearch $maintypes $tname] == -1} {
			append dmsg "\[*inv*\] "
			incr errcnt
		} else {
			append dmsg "\[valid\] "
		}
		if {[lsearch $subtypes $sname] == -1} {
			append dmsg "\[*inv*\] $sname"
			incr errcnt
		} else {
			append dmsg "\[valid\] "
		}
		append dmsg $filed
		puts $dmsg
		if {$errcnt > 0} {lappend eros $dmsg}
	}
	}
}

proc mkv {} {
	global eros
	set maintype "1A45DFA3"
	set subtype "93428288 A3428681 01000000" ;# last one is HEVC sometimes
	if ![catch {glob *.mkv} files] {
	foreach filed $files {
		set errcnt 0
		if ![file isfile $filed] {continue}
		catch {open $filed r} of
		if {![file readable $filed] || ![string match "file*" $of]} {puts "$filed is not readable ..." ; continue}
		fconfigure $of -translation binary
		binary scan [read $of 4] H8 tname
		binary scan [read $of 4] H8 sname
		set dmsg ""
		if {![string equal $maintype [string toupper $tname]]} {
			append dmsg "\[*inv*\] "
			incr errcnt
		} else {
			append dmsg "\[valid\] "
		}
		if {[lsearch $subtype [string toupper $sname]] == -1} {
			append dmsg "\[*inv*\] "
			incr errcnt
		} else {
			append dmsg "\[valid\] "
		}
		append dmsg $filed
		puts $dmsg
		if {$errcnt > 0} {lappend eros $dmsg}
	}
	}
}

proc avi {} {
	global eros
	set subtypes "{AVI } ODML"
	if ![catch {glob *.avi} files] {
	foreach filed $files {
		set errcnt 0
		if ![file isfile $filed] {continue}
		catch {open $filed r} of
		if {![file readable $filed] || ![string match "file*" $of]} {puts "$filed is not readable ..." ; continue}
		fconfigure $of -translation binary
		binary scan [read $of 4] a* tname
		binary scan [read $of 4] c chunk 
		binary scan [read $of 4] a* sname
		set dmsg ""
		if ![string equal "RIFF" $tname] {
			append dmsg "\[*inv*\] "
			incr errcnt
		} else {
			append dmsg "\[valid\] "
		}
		if {[lsearch $subtypes $sname] == -1} {
			append dmsg "\[*inv*\] "
			incr errcnt
		} else {
			append dmsg "\[valid\] "
		}
		append dmsg $filed
		puts $dmsg
		if {$errcnt > 0} {lappend eros $dmsg}
	}
	}
}

proc wmv {} {
	global eros
	set sighex "3026B275"
	set sigsub "8E66CF11"
	if ![catch {glob *.wmv} files] {
	foreach filed $files {
		set errcnt 0
		if ![file isfile $filed] {continue}
		catch {open $filed r} of
		if {![file readable $filed] || ![string match "file*" $of]} {puts "$filed is not readable ..." ; continue}
		fconfigure $of -translation binary
		binary scan [read $of 4] H8 tname
		binary scan [read $of 4] H8 sname
		set dmsg ""
		if {![string equal $sighex [string toupper $tname]]} {
			append dmsg "\[*inv*\] "
			incr errcnt
		} else {
			append dmsg "\[valid\] "
		}
		if {![string equal $sigsub [string toupper $sname]]} {
			append dmsg "\[*inv*\] "
			incr errcnt
		} else {
			append dmsg "\[valid\] "
		}
		append dmsg $filed
		puts $dmsg
		if {$errcnt > 0} {lappend eros $dmsg}
	}
	}
}

mp4
wmv
mkv
mov
avi
logwrite
