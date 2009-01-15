Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:33659 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbZAOQbv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 11:31:51 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: Lots of minstrel WARN_ONS with current -git
Date: Thu, 15 Jan 2009 17:31:56 +0100
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1231973480.5147.2.camel@brick> <200901151633.11794.mb@bu3sch.de>
In-Reply-To: <200901151633.11794.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901151731.56758.chunkeey@web.de> (sfid-20090115_173156_856358_C2F4DCD0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 15 January 2009 16:33:11 Michael Buesch wrote:
> On Wednesday 14 January 2009 23:51:20 Harvey Harrison wrote:
> > Seeing lots of these WARN_ONS with current -git.  Known issue?
> > 
> > b43 hardware.
> > 
> > [41850.615621] WARNING: at net/mac80211/rc80211_minstrel.c:69 minstrel_rate_init+0x92/0x3c0()
> 
> I think that happens, if you have a b-only AP.

erm, see : "minstrel: fix warning if lowest supported rate index is not 0"
( http://www.spinics.net/lists/linux-wireless/msg25799.html )

The fix is in wireless-testing & wireless-next since a few days now...
Or is this a new bug?

Regards,
	Chr
