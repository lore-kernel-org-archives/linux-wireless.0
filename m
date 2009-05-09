Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:39798 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbZEIW3u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2009 18:29:50 -0400
Subject: Re: IPV6 testing... Re: [PATCH] ath9k: Fix FIF_BCN_PRBRESP_PROMISC
 handling
From: David Woodhouse <dwmw2@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: lrodriguez@atheros.com, stable@kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090509.122936.242607926.davem@davemloft.net>
References: <20090506000410.GC3436@tesla>
	 <1241858970.2910.63.camel@macbook.infradead.org>
	 <20090509.122936.242607926.davem@davemloft.net>
Content-Type: text/plain
Date: Sat, 09 May 2009 23:29:40 +0100
Message-Id: <1241908180.24436.32.camel@macbook.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-05-09 at 12:29 -0700, David Miller wrote:
> I pretty much never test IPV6 and I'm not embarassed.  Really, I
> simply do not use it and have no interest in IPV6 at all.  It's simply
> not on my radar.  I'll work on ipv6 bugs, but as far as using it
> actively and testing every driver I write with it, NO WAY.

I wasn't suggesting that you should care about IPv6, per se.

I was suggesting that you should care about Ethernet multicast.

And the simplest way of testing that seems to be to use IPv6.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

