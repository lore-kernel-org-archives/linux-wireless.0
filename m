Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44074
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751510AbYKKASv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 19:18:51 -0500
Date: Mon, 10 Nov 2008 16:18:51 -0800 (PST)
Message-Id: <20081110.161851.25101606.davem@davemloft.net> (sfid-20081111_011856_571497_FAB402A8)
To: johannes@sipsolutions.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2008-11-10
From: David Miller <davem@davemloft.net>
In-Reply-To: <1226361148.3650.22.camel@johannes.berg>
References: <20081110204500.GL3546@tuxdriver.com>
	<20081110.133054.154011074.davem@davemloft.net>
	<1226361148.3650.22.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 11 Nov 2008 00:52:28 +0100

> On Mon, 2008-11-10 at 13:30 -0800, David Miller wrote:
> 
> > BTW, I noticed that print_ssid() is a good candidate for a new
> > %pX format specifier extension, just like how we got rid of
> > print_mac(), NIPQUAD() and friends recently in the net-next
> > tree.
> 
> I was thinking about that too, but unless we want to do something like
> adding %pSSID I think we shouldn't do this for so few users.

Fair enough.
