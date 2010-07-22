Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:16926 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab0GVQeo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 12:34:44 -0400
Subject: Re: wl1271 firmware
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Pazzo Da Legare <pazzodalegare@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Levi, Shahar" <shahar_levi@ti.com>,
	Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <AANLkTilZhvGg2SUk5btpQQA3qj2k4rob4rTychDu7gXM@mail.gmail.com>
References: <4C37BCA0.5090607@deltatee.com>
	 <AC090B9732AB2B4DB7FF476E907FE660010685F34E@dnce02.ent.ti.com>
	 <AANLkTilHNKeRZX5CMplyriTo2hTPBrz_z1_Zpwoy3SZx@mail.gmail.com>
	 <AC090B9732AB2B4DB7FF476E907FE66001069662F2@dnce02.ent.ti.com>
	 <AC090B9732AB2B4DB7FF476E907FE6600106966BA5@dnce02.ent.ti.com>
	 <4C45ED36.2090604@deltatee.com>
	 <AANLkTinjvF9UeV7d2aBUy6HfexuAeL_cdsVPGVxSRVMp@mail.gmail.com>
	 <AANLkTinnYeJPV-xxg7DdPXnWW_kD7X1TVcd9HrhupJWS@mail.gmail.com>
	 <1279780848.2322.31.camel@powerslave>
	 <AANLkTilZhvGg2SUk5btpQQA3qj2k4rob4rTychDu7gXM@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 19:34:25 +0300
Message-ID: <1279816465.1630.9.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-07-22 at 17:41 +0200, ext Pazzo Da Legare wrote:
> I enabled the DEBUG_LEVEL as you advice me but I have no additional
> information....
> 
> [  186.230000] wl1271_sdio mmc0:0001:2: firmware: requesting
> wl1271-fw.bin
> [  186.420000] wl1271_sdio mmc0:0001:2: firmware: requesting
> wl1271-nvs.bin
> [  186.860000] wl1271: firmware booted (Rev 6.1.0.0.310)
> [  186.880000] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  187.380000] wl1271: ERROR ELP wakeup timeout!
> [  187.880000] wl1271: ERROR ELP wakeup timeout!

There's something wrong.  There should have been a lot more traces with
the DEBUG_LEVEL I proposed.  Please try again.


-- 
Cheers,
Luca.

