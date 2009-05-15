Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:60014 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753119AbZEOB1M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 21:27:12 -0400
Date: Thu, 14 May 2009 22:27:10 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>, Will Keaney <keaneyw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFT v9] rfkill: rewrite
Message-ID: <20090515012710.GC21718@khazad-dum.debian.net>
References: <1242030669.6930.10.camel@johannes.local> <4A09B130.9000106@gmail.com> <1242151180.3203.19.camel@localhost.localdomain> <1242151479.11924.4.camel@johannes.local> <20090513214004.GE26299@khazad-dum.debian.net> <1242253192.10076.3.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1242253192.10076.3.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 14 May 2009, Johannes Berg wrote:
> > As for the issue Dan reported, I have _no_ _idea_ of what it might be
> > causing it, and a bissect would help wonders.  It will have to be fixed
> > anyway (even if it is also fixed by the rfkill rewrite) if it is hosing
> > 2.6.30 :-(
> 
> Dan? Now I'm confused? You mean Will's issue? Does thinkpad do LED

Probably.

> stuff? That's the only thing we changed recently in the current rfkill

Yes, thinkpad does LED stuff... but not on the rfkill path I think.
Although one could certainly use a rfkill trigger on one of the thinkpad
leds, and that would tie the two together...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
