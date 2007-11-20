Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:52706 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993AbXKTRiv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 12:38:51 -0500
Date: Tue, 20 Nov 2007 09:38:29 -0800
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>, shaddy_baddah@hotmail.com,
	linux-wireless@vger.kernel.org, dsd@gentoo.org
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
Message-ID: <20071120173829.GA1480@bougret.hpl.hp.com> (sfid-20071120_173853_574592_00F380CB)
Reply-To: jt@hpl.hp.com
References: <4740DF47.4040206@hotmail.com> <20071119.002755.77617097.davem@davemloft.net> <1195484582.8642.18.camel@johannes.berg> <20071119.142046.188284555.davem@davemloft.net> <1195562454.10920.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1195562454.10920.6.camel@johannes.berg>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 20, 2007 at 01:40:54PM +0100, Johannes Berg wrote:
> 
> Well, I complained too but it's unfixable without breaking one thing or
> the other, consider netlink messages with iw_point in them that are
> broadcast. Ugh.

	Actually, iw_point are never included in netlink messages.

> johannes

	Jean


