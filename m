Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45727 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab2FRSEF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 14:04:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SggJ0-0007hQ-Ho
	for linux-wireless@vger.kernel.org; Mon, 18 Jun 2012 20:04:02 +0200
Received: from 141.215.239.88 ([141.215.239.88])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 20:04:02 +0200
Received: from ilhebe999 by 141.215.239.88 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 20:04:02 +0200
To: linux-wireless@vger.kernel.org
From: Ouyang <ilhebe999@gmail.com>
Subject: Re: make moduels tx.c error
Date: Mon, 18 Jun 2012 18:03:52 +0000 (UTC)
Message-ID: <loom.20120618T200055-644@post.gmane.org> (sfid-20120618_200410_827350_B0D7AEBA)
References: <loom.20120617T234255-222@post.gmane.org> <4FDEC547.1080701@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Randy Dunlap <rdunlap@...> writes:

> 
> On 06/17/2012 02:45 PM, Ouyang wrote:
> 
> >  Anyone can tell me how to figure this problem? I do not have much 
experience on
> > linux kernel compiling.
> > make modules
> > make[1]: Nothing to be done for `all'.
> >   CHK     include/linux/version.h
> >   CHK     include/generated/utsrelease.h
> >   CALL    scripts/checksyscalls.sh
> >   CC [M]  net/mac80211/tx.o
> > net/mac80211/tx.c: In function ‘ieee80211_tx’:
> > net/mac80211/tx.c:1327:2: error: implicit declaration of function
> > ‘ieee80211_tx_prepare’ [-W
> > net/mac80211/tx.c: At top level:
> > net/mac80211/tx.c:1601:1: error: conflicting types for 
‘ieee80211_tx_prepare’
> > net/mac80211/tx.c:1327:16: note: previous implicit declaration of
> > ‘ieee80211_tx_prepare’ was
> > net/mac80211/tx.c: In function ‘ieee80211_tx_prepare’:
> > net/mac80211/tx.c:1643:7: warning: passing argument 1 of
> > ‘__ieee80211_parse_tx_radiotap’ fro
> > net/mac80211/tx.c:1516:13: note: expected ‘struct sk_buff *’ but argument 
is of
> > type ‘struct
> > net/mac80211/tx.c:1643:7: error: too many arguments to function
> > ‘__ieee80211_parse_tx_radiot
> > net/mac80211/tx.c:1516:13: note: declared here
> > net/mac80211/tx.c: In function ‘ieee80211_monitor_start_xmit’:
> > net/mac80211/tx.c:1790:2: error: implicit declaration of function
> > ‘ieee80211_parse_tx_radiot
> > cc1: some warnings being treated as errors
> > make[2]: *** [net/mac80211/tx.o] Error 1
> > make[1]: *** [net/mac80211] Error 2
> > make: *** [net] Error 2
> 
> What kernel version is this?
> 
> What commands did you use to do the build?
> 
> thanks,
> 

 The version of the kernel is 3.1.0-7.fc16.x86_64, I just add a few codes to 
the functions and it could not compile successfully,.
 After I installed ncurses-devel, I used the command "make menuconfig", but I 
did not change anything, just the default value. and then, "make modules". It 
goes as showed previously.

 Thank you so much for the advice and I will take it seriously even though 
the problems are still not solved

