Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blaine.gmane.org ([80.91.229.8]:39004 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbYKNIen (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 03:34:43 -0500
Received: from public by hugh.gmane.org with local (Exim 4.63)
	(envelope-from <public@hugh.gmane.org>)
	id 1L0u8T-0006E1-L0
	for linux-wireless@vger.kernel.org; Fri, 14 Nov 2008 09:34:37 +0100
Message-ID: <491D380D.7050707@teltonika.lt> (sfid-20081114_093448_463864_C33EB791)
Date: Fri, 14 Nov 2008 10:34:21 +0200
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
MIME-Version: 1.0
To: Johannes Berg
	<public-johannes-cdvu00un1VgdHxzADdlk8Q@hugh.gmane.org>
CC: "otus-devel-qhrM8SXbD5K0lq1k9DReS6gKWPgB4RSr2LY78lusg7I@public.gmane.org"
	<public-otus-devel-qhrM8SXbD5K0lq1k9DReS6gKWPgB4RSr2LY78lusg7I@hugh.gmane.org>,
	linux-wireless
	<public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
	Greg KH <greg@kroah.com>
Subject: Re: [FYI] ar9170 driver
References: <1226531034.14186.39.camel@johannes.berg>
In-Reply-To: <1226531034.14186.39.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Johannes Berg wrote:
> This patch adds the ar9170 driver for Atheros 802.11n
> USB hardware ("otus").
> 
> NOTES/TODO
>  * locks up RX part of the device after a while and the device
>    starts messing with the USB bus
>    (message will be "complete rx %p (0b, -75)")
>  * need to implement RF, TX power calibration based on EEPROM
>    values (maybe causing the RX hangs? doubt it)
>  * already needs some code cleanups
>  * use rate hw_value instead of huge switch statement
>  * implement configure_filter
>  * implement bss_config call
>  * implement beaconing
>  * implement hardware crypto
>  * implement AP mode
>  * implement mesh mode

If this driver is not going in through wireless or any other tree, because it
still needs some work, maybe it is worth to get it to staging tree maintained
by Greg?

> Signed-off-by: Johannes Berg <johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>

