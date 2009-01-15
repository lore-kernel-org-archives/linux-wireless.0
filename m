Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:58775 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbZAORNw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 12:13:52 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: Lots of minstrel WARN_ONS with current -git
Date: Thu, 15 Jan 2009 18:13:57 +0100
Cc: Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1231973480.5147.2.camel@brick> <200901151731.56758.chunkeey@web.de> <1232038251.5595.0.camel@brick>
In-Reply-To: <1232038251.5595.0.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901151813.57146.chunkeey@web.de> (sfid-20090115_181357_755138_D86FE63C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 15 January 2009 17:50:51 Harvey Harrison wrote:
> On Thu, 2009-01-15 at 17:31 +0100, Christian Lamparter wrote:
> > On Thursday 15 January 2009 16:33:11 Michael Buesch wrote:
> > > On Wednesday 14 January 2009 23:51:20 Harvey Harrison wrote:
> > > > Seeing lots of these WARN_ONS with current -git.  Known issue?
> > > > 
> > > > b43 hardware.
> > > > 
> > > > [41850.615621] WARNING: at net/mac80211/rc80211_minstrel.c:69 minstrel_rate_init+0x92/0x3c0()
> > > 
> > > I think that happens, if you have a b-only AP.
> > 
> > erm, see : "minstrel: fix warning if lowest supported rate index is not 0"
> > ( http://www.spinics.net/lists/linux-wireless/msg25799.html )
> > 
> > The fix is in wireless-testing & wireless-next since a few days now...
> > Or is this a new bug?
> 
> I'll try that out shortly, report was against linus mainline.
> 
Oh? with 2.6.28 or the current 2.6.29-rcX line?
If you get this WARNING with 2.6.29-rcX, you don't have to worry...
http://patchwork.kernel.org/patch/2184/

Regards,
	Chr
