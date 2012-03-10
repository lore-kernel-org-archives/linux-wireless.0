Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38198 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab2CKWFL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Mar 2012 18:05:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1S6qsy-0002fV-KY
	for linux-wireless@vger.kernel.org; Sun, 11 Mar 2012 23:05:04 +0100
Received: from 234-87-136-186.fibertel.com.ar ([234-87-136-186.fibertel.com.ar])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 11 Mar 2012 23:05:04 +0100
Received: from damianmontaldo by 234-87-136-186.fibertel.com.ar with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 11 Mar 2012 23:05:04 +0100
To: linux-wireless@vger.kernel.org
From: Damian Montaldo <damianmontaldo@gmail.com>
Subject: Re: Fwd: Can't compile latest compat-wireless on Fedora 16 -  =?utf-8?b?My4yLjctMS5mYzE2Lng4Nl82NC5kZWJ1Zw==?=
Date: Sat, 10 Mar 2012 19:02:53 +0000 (UTC)
Message-ID: <loom.20120310T195728-825@post.gmane.org> (sfid-20120311_230546_485483_A38CCA9B)
References: <f4dafaf24a15bdee30366ec46f4e8429@www.thefabfarrows.com> <591bc8272f5a32225a4ca6f8ae8c2773@www.thefabfarrows.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Paul Farrow <linuxwireless@...> writes:
> On Tue, 28 Feb 2012 15:00:24 -0500, Paul Farrow wrote:
> > Hi guys
> >
> > I have in recent times compiled the latest compat-wireless with no
> > problem but I seem to be having trouble compiling it on this kernel -
> > lots of undefined warnings in the mac80211 area.
> >
> > Output from make is attached.
> >
> > Can any one tell me what I have done wrong?
> >
> > Thanks
> >
> > Paul
> 
> 
> 
> [ 7821.750967] ath9k 0000:03:00.0: PCI INT A disabled
> [ 7821.751115] ath9k: Driver unloaded


Hi, I have the same errors trying to compile compat-wireless-2012-03-08 (the
last stable version available) in kubuntu oneiric with kernel 3.0.0-16-generic
(up-to-date) x86_64

 [   13.194249] mac80211: Unknown symbol __tracepoint_drv_start (err 0)
 [   13.194292] mac80211: Unknown symbol __tracepoint_drv_finish_tx_sync (err 0)
 [   13.194302] mac80211: Unknown symbol __tracepoint_drv_sta_remove (err 0)
 [   13.194312] mac80211: Unknown symbol __tracepoint_drv_conf_tx (err 0)
 [   13.194321] mac80211: Unknown symbol
__tracepoint_drv_cancel_remain_on_channel (err 0)
 [   13.194356] mac80211: Unknown symbol __tracepoint_drv_remain_on_channel (err 0)
...etc...

any idea?

