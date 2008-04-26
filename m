Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.dnainternet.fi ([87.94.96.108]:60185 "EHLO
	smtp1.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbYDZVkz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2008 17:40:55 -0400
Message-ID: <20080427004052.5sespv7h6o4wk8c0@hayate.ip6> (sfid-20080426_234112_275473_89BF56B3)
Date: Sun, 27 Apr 2008 00:40:52 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: compat-2.6: rndis_wlan/rndis_host/usbnet problem(?)
References: <20080421200409.vvow4d67okcw84kg@hayate.ip6>
	<20080426045909.GA17936@ruslug.rutgers.edu>
	<20080426181848.foifd2bcw004kw4g@naisho.dyndns.info>
	<43e72e890804261126n7c4463c9y2d4bb4dc444be096@mail.gmail.com>
In-Reply-To: <43e72e890804261126n7c4463c9y2d4bb4dc444be096@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "Luis R. Rodriguez" <mcgrof@gmail.com>:

>
> Does the driver rely on all the new stuff? Or just he one you mentioned?
>

Driver rely on the patch adding 'driver_priv' pointer to 'struct  
usbnet' and the cdc_ether.c patch. Without cdc_ether.c patch, device  
fails to bind. With those patches + rndis_* changes, driver should  
work (atleast) on 2.6.20 and up. I'll check this when I find some time.

  - Jussi



