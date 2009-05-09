Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59484
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752245AbZEIT3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2009 15:29:40 -0400
Date: Sat, 09 May 2009 12:29:36 -0700 (PDT)
Message-Id: <20090509.122936.242607926.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: lrodriguez@atheros.com, stable@kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: IPV6 testing... Re: [PATCH] ath9k: Fix FIF_BCN_PRBRESP_PROMISC
 handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <1241858970.2910.63.camel@macbook.infradead.org>
References: <20090506000410.GC3436@tesla>
	<1241858970.2910.63.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Woodhouse <dwmw2@infradead.org>
Date: Sat, 09 May 2009 09:49:30 +0100

> Btw, people ought to be _really_ embarrassed by this. It shows that you
> never even bothered to try a simple IPv6 ping to/from a machine with
> this driver.
> 
> You should _ALWAYS_ test network drivers with IPv6; it exercises
> multicast paths that Legacy IP won't usually touch.

I pretty much never test IPV6 and I'm not embarassed.  Really, I
simply do not use it and have no interest in IPV6 at all.  It's simply
not on my radar.  I'll work on ipv6 bugs, but as far as using it
actively and testing every driver I write with it, NO WAY.

And that is OK.

Nobody else should be embarrased about failing to test ipv6 either.
Don't be rediculious David.

The community will test that eventually, find the problems, and the
bugs will get fixed.  End of story.
