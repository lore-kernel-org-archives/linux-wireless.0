Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:45762 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336AbXIFCim (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2007 22:38:42 -0400
Date: Wed, 5 Sep 2007 19:38:24 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] hostapd: use nl80211 instead of prism ioctls to create  interfaces
Message-ID: <20070906023824.GK5273@jm.kir.nu>
References: <1187987850.24933.29.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1187987850.24933.29.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 24, 2007 at 10:37:30PM +0200, Johannes Berg wrote:
> This makes hostapd use nl80211 (via libnl) to create/remove interfaces.
> Also lays the foundation for using nl80211 in hostapd.

Thanks, applied.

> I have tested this code with the patch to use monitor interfaces instead
> of the management interface, but wasn't able to test exactly these code
> paths because none of the cards we have drivers for currently allow
> multiple BSSes.

I haven't had a chance of testing this yet, but at least I'm now back in
state where I can build everything successfully :-). I will be traveling
next couple of weeks at IEEE 802.11 meetings and will be very unlikely
to test this any time soon (especially so, taken into account where the
meetings are this time.. getting two meetings on consecutive weeks and
on two Hawaiian islands is quite a nice combination ;-). Consequently,
it is probably best to just get this in now and we'll fix multi-BSS
things later, if needed.

-- 
Jouni Malinen                                            PGP id EFC895FA
