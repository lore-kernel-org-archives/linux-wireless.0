Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:44664 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753009Ab0KTVYa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Nov 2010 16:24:30 -0500
Date: Sat, 20 Nov 2010 23:24:25 +0200
From: Jouni Malinen <j@w1.fi>
To: Wolfgang Breyha <wbreyha@gmx.net>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Linux Client vs. CISCO AP with band select
Message-ID: <20101120212424.GA14471@jm.kir.nu>
References: <4CE6EA98.3020300@gmx.net>
 <20101120112753.GA12225@jm.kir.nu>
 <201011201304.48821.helmut.schaa@googlemail.com>
 <4CE7FC1A.3070709@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4CE7FC1A.3070709@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 20, 2010 at 05:49:30PM +0100, Wolfgang Breyha wrote:
> We tried to deactivate "band select" already and my laptop was able to
> connect instantly to the nearest 2.4GHz AP. But that's the point where the
> second "feature" kicks in. "load balancing" is then used by the APs to kick
> stations trying to push them to an other AP. At this point Linux clients
> have troubles again to get a stable connection.

Could you please send a wpa_supplicant debug log for this one, too? If
the AP is just kicking out the station, we should be able to blacklist
the AP and try to find someone else..

I've seen number of issues with load balancing designs in the past, but
I think I fixed many of them the last time I was testing this.. It's a
bit pity that I don't have this type of "enterprise AP" test setup at
home to remind me that things are not working. I usually end up
debugging this only when traveling and getting hit by connectivity
issues myself.

-- 
Jouni Malinen                                            PGP id EFC895FA
