Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:34853 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756702AbYHCVPJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 17:15:09 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KPkus-00057P-Ow
	for linux-wireless@vger.kernel.org; Sun, 03 Aug 2008 21:15:02 +0000
Received: from bec220.neoplus.adsl.tpnet.pl ([83.28.14.220])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2008 21:15:02 +0000
Received: from kamil.dzida by bec220.neoplus.adsl.tpnet.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2008 21:15:02 +0000
To: linux-wireless@vger.kernel.org
From: Kamil Dzida <kamil.dzida@gmail.com>
Subject: Re: Q: support for AVM Fritz! WLAN USB in kernel 2.6.25+
Date: Sun, 3 Aug 2008 21:10:29 +0000 (UTC)
Message-ID: <loom.20080803T210907-156@post.gmane.org> (sfid-20080803_231512_830190_CAF6E271)
References: <20080731165054.GA14485@tuxdriver.com> <4892391D.2010305@imap.cc> <20080731224357.GA9741@localhost.localdomain> <48939C97.5030608@imap.cc> <20080802082851.GB8213@frodo> <4894D86A.6030108@imap.cc> <20080802231201.GB23361@frodo> <4894FF97.7040600@imap.cc> <20080803005715.GD23361@frodo> <20080803034341.GA8963@kroah.com> <20080803091131.GE23361@frodo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felipe Balbi <me@...> writes:

> 
> Hi Greg,
> 
> On Sat, Aug 02, 2008 at 08:43:41PM -0700, Greg KH wrote:
> > I'd be glad to do that, anyone have a link to it?
> 
> http://sourceforge.net/project/showfiles.php?group_id=75380&package_id=75880
> 
> I suppose it's better to get the mac80211 version.
> 


WAIT! (sorry)

As far as I remember ACX project was was meant to be merged long time ago, but
it was halted because it's unknown legal status. The developers did not use
"clean room" while reverse engineering. This means that the same people who
reverse engineered the proprietary Texas Instruments driver wrote the linux
driver. No one says that the developers copied some TI code but after problems
with S.C.O. Group, Mr. Linville doesn't want any future trouble. Pulling ACX
code to any common tree without consulting Mr. Linville first is a bad idea.


