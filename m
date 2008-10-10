Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:45791 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759557AbYJJQUJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 12:20:09 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KoKih-0005Ad-3d
	for linux-wireless@vger.kernel.org; Fri, 10 Oct 2008 16:20:03 +0000
Received: from 117.47.113.109 ([117.47.113.109])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2008 16:20:03 +0000
Received: from tech by 117.47.113.109 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2008 16:20:03 +0000
To: linux-wireless@vger.kernel.org
From: stephen mcgregor <tech@stephen-mcgregor.com>
Subject: newbie question. cant get fw-cutter to extract the firmware.
Date: Fri, 10 Oct 2008 16:10:06 +0000 (UTC)
Message-ID: <loom.20081010T155930-255@post.gmane.org> (sfid-20081010_182027_074934_337844AD)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone

I was getting dmesg messages re: you must upgrade to version 4 to get this to 
work. So I found the latest version of the (broadcom-wl-4.150.10.5.2.tar) 
tarball, dated september 2008, and tried to extract the firmware from that.

my problem is that fw-cutter, as per the following messages, can't extract the 
required code.  It seems that version 11 is the latest version of fw-cutter, 
so no ability to change there. 

What should I do as a next step ? 

note that I could extract the firmware from the previous version of the 
tarball, but that I recieved 'upgrde to revision 4' dmesg messages.

I haven't included lspci or uname info, as I think my problem is simpler 
(stupider) than that. It seems to me that my question is about tarball and fw-
cutter compatability.  

thanks for any help

regards

Stephen


=====================================================================

--normal operation  --

prompt > ../../../b43-fwcutter-011/b43-fwcutter -w "$FIRMWARE_INSTALL_DIR" 
wl_apsta_mimo.o
Sorry, the input file is either wrong or not supported by b43-fwcutter.
This file has an unknown MD5sum b6d32979ad3fdd8ce5c3ec806ebec757.

-- with the unsupported option --

prompt > ../../../b43-fwcutter-011/b43-fwcutter -w "$FIRMWARE_INSTALL_DIR"  --
unsupported  wl_apsta_mimo.o
Sorry, the input file is either wrong or not supported by b43-fwcutter.
This file has an unknown MD5sum b6d32979ad3fdd8ce5c3ec806ebec757.


prompt > ../../../b43-fwcutter-011/b43-fwcutter -w "$FIRMWARE_INSTALL_DIR"  --
unsupported  wl_apsta.o
Sorry, the input file is either wrong or not supported by b43-fwcutter.
This file has an unknown MD5sum 9852dda7680b95245e45f0769a26c00c.


--fw-cutter version --

/home/bench/systemMaintenance/wireless/b43/sept08/broadcom-wl-
4.150.10.5.2/driver > ../../../b43-fwcutter-011/b43-fwcutter -v
b43-fwcutter version 011

===========================================================================

