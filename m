Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:43441
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031297AbXDQXgU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2007 19:36:20 -0400
From: Michael Buesch <mb@bu3sch.de>
To: jt@hpl.hp.com
Subject: Re: [PATCH 2.6] WE-22 : prevent information leak on 64 bit
Date: Wed, 18 Apr 2007 01:34:50 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev@vger.kernel.org
References: <20070323003116.GC2712@bougret.hpl.hp.com> <1175508410.23438.75.camel@johannes.berg> <20070417170820.GB22372@bougret.hpl.hp.com>
In-Reply-To: <20070417170820.GB22372@bougret.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200704180134.50571.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 17 April 2007 19:08, Jean Tourrilhes wrote:
> 	I'm sorry to have to write this e-mail. But this incident is
> completely opposed to the ideal of FreeSoftware/OpenSource and
> demonstrate some of the bad politics happening in Linux.
> 
> 	First, I'm the current active maintainer of the
> wext-over-netlink interface, and nobody bothered to even 'inform' me
> about its removal, let alone consult with me.
> 	This shows a complete lack of courtesy and a total disrespect
> to the concept of maintainer, basically some people are just second
> class citizens.
> 
> 	Second, there is no technical justification to such decision,
> it's just plain politics. I would agree that for the vast majority of
> people, this API was useless, as any work in progress. But, it is
> maintained (by me), it is not causing any technical issue, for those
> people it's not compiled in (i.e. no bloat), it is not causing bugs
> and not preventing other code to be merged in the kernel.
> 	Therefore a purely politic decision.

It is _only_ about replacing obsolete code by code that obsoleted it.
That happens all the time. Look at the process scheduler and compare
it to 2.4, for example.

We want to reduce the maintainance burden. Nothing more.
If we remove unused code (which WEXT-NL is), then we don't have to
write compatibility code to support it in future.
Why wait with removal until we can't anymore (when people use it)?

> 	Now, I've got a problem with your attitude in this matter,
> Johannes. It's now the second time you remove features from code I
> maintain by pure fiat, and you have engaged in a long running FUD
> campain about my code. This is totally disgraceful of a Linux
> maintainer, and you should know it.
> 	If the only way you have to promote your code is by actively
> destroying my code, then you have a real issue. Your code should stand
> on its own merit, without the need of attacking other people's work
> and playing political tricks.
> 	I hope you will note that I never disparaged your code, I
> never prevented its inclusion in Linux and I never attempted to
> control the Linux Wireless space and left plenty of space for new
> developpers.
> 
> 	You still have a lot to learn, like all of us. You still don't
> understand Wireless Extensions (as your FUD shows) and why it's still
> so popular despite all its warts. You don't get the value of not
> burning bridges with other developpers and professional conduct.

I'd say nobody but you does fully understand WEXT. Somebody might
call that either a design issue, or a documentation issue.
I personally make both issues responsible for this.

-- 
Greetings Michael.
