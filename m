Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:58057 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab2KMHeM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 02:34:12 -0500
Message-ID: <1352792012.28369.10.camel@cumari.coelho.fi> (sfid-20121113_083416_155390_E736412E)
Subject: Re: [PATCH 1/2] wlcore: add power callback for SPI
From: Luciano Coelho <coelho@ti.com>
To: <Janusz.Dziedzic@tieto.com>
CC: <linux-wireless@vger.kernel.org>, <arik@wizery.com>
Date: Tue, 13 Nov 2012 09:33:32 +0200
In-Reply-To: <3078A9B976EF864C8DDD0C499FFD07912383D6479F@EXMB01.eu.tieto.com>
References: <3078A9B976EF864C8DDD0C499FFD07912383D6479F@EXMB01.eu.tieto.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Now I see that you have already sent the patch I proposed you to
send. ;)

On Wed, 2012-11-07 at 15:42 +0200, Janusz.Dziedzic@tieto.com wrote:
> Add power callback also for SPI.
> This will also fix a dump:
> 
> [  143.111602] Unable to handle kernel NULL pointer dereference at
> virtual address 00000000
> [  143.150573] pgd = dda58000
> [  143.153472] [00000000] *pgd=9d812831, *pte=00000000, *ppte=00000000
> [  143.181091] Internal error: Oops: 80000007 [#1] PREEMPT ARM
> [  143.186981] Modules linked in: wlcore_spi(+) wl12xx wlcore mac80211
> cfg80211 atmel_mxt pvrsrvkm ipv6

[...]

> [  143.267578] 3da0:                                     dddad8e0
> dddaeb70 00000008 dddad8e0
> [  143.276153] 3dc0: 00000000 bf175ff8 ddfefa50 dddad8e0 ddfef808
> c02bd12c 00000000 bf194f24
> [  143.284729] 3de0: 00000000 c02be138 c02be124 c02bcf78 c02be318
> ddfef808 c02bd12c 00000000
> [  143.293304] 3e00: 00000000 c02bb968 de4038d8 dd8bed54 ddfef808
> ddfef83c ddfef808 c02bd208
> [  143.301879] 3e20: ddfef808 c06a8af0 ddfef808 c02bc394 ddfef808
> ddfef810 de700c00 c02bb24c
> [  143.310485] 3e40: ddfef810 00000000 00000000 de700c00 00000000
> c0259ad4 ddfef800 ddfef800

Please don't wrap these lines.  It's hard to read the dump like this.

--
Cheers,
Luca.

