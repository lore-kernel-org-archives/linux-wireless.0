Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:59962 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbZAOQux (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 11:50:53 -0500
Received: by wf-out-1314.google.com with SMTP id 27so1360227wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2009 08:50:52 -0800 (PST)
Subject: Re: Lots of minstrel WARN_ONS with current -git
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200901151731.56758.chunkeey@web.de>
References: <1231973480.5147.2.camel@brick>
	 <200901151633.11794.mb@bu3sch.de>  <200901151731.56758.chunkeey@web.de>
Content-Type: text/plain
Date: Thu, 15 Jan 2009 08:50:51 -0800
Message-Id: <1232038251.5595.0.camel@brick> (sfid-20090115_175058_845913_D820C609)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-01-15 at 17:31 +0100, Christian Lamparter wrote:
> On Thursday 15 January 2009 16:33:11 Michael Buesch wrote:
> > On Wednesday 14 January 2009 23:51:20 Harvey Harrison wrote:
> > > Seeing lots of these WARN_ONS with current -git.  Known issue?
> > > 
> > > b43 hardware.
> > > 
> > > [41850.615621] WARNING: at net/mac80211/rc80211_minstrel.c:69 minstrel_rate_init+0x92/0x3c0()
> > 
> > I think that happens, if you have a b-only AP.
> 
> erm, see : "minstrel: fix warning if lowest supported rate index is not 0"
> ( http://www.spinics.net/lists/linux-wireless/msg25799.html )
> 
> The fix is in wireless-testing & wireless-next since a few days now...
> Or is this a new bug?

I'll try that out shortly, report was against linus mainline.

Harvey

