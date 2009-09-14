Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:51655 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbZINUpx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 16:45:53 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Kernel oops with 2.6.31-wl
Date: Mon, 14 Sep 2009 22:45:49 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
References: <4AAE4DAA.1010505@lwfinger.net> <1252950017.23427.49.camel@johannes.local> <4AAE8965.4040108@lwfinger.net>
In-Reply-To: <4AAE8965.4040108@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909142245.52042.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 14 September 2009 20:20:21 Larry Finger wrote:
> Johannes Berg wrote:
> > On Mon, 2009-09-14 at 09:05 -0500, Larry Finger wrote:
> >> Using the kernel v2.6.31-38241-g2d3a51e, I get the following kernel
> >> oops when unloading b43:
> > 
> >> RIP: 0010:[<ffffffffa02a3a3e>]  [<ffffffffa02a3a3e>]
> >> b43_op_config+0x10c/0x36f [b43]
> > 
> > Seems like a b43 problem to me.
> 
> I had pretty much reached that conclusion. I will need to swap cards
> to debug as the 4315 won't run on older kernels without a lot of patches.

I can't reproduce here. What sequence of events is needed to trigger this?


-- 
Greetings, Michael.
