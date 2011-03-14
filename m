Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36639 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab1CNSxD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 14:53:03 -0400
Date: Mon, 14 Mar 2011 14:50:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?iso-8859-1?Q?T=F5nu?= Samuel <tonu@jes.ee>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] zd1211rw: TrendNet TEW-509UB id added
Message-ID: <20110314185021.GB2525@tuxdriver.com>
References: <1299922165.3044.1.camel@hp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1299922165.3044.1.camel@hp>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 12, 2011 at 11:29:25AM +0200, Tõnu Samuel wrote:
> 

Missing a Signed-off-by line here...

	http://linux.yyz.us/patch-format.html

Also, best to send wireless LAN patches to
linux-wireless@vger.kernel.org instead.

Thanks,

John

> --- ./drivers/net/wireless/zd1211rw/zd_usb.c	2011-03-08 01:05:50.000000000 +0200
> +++ /usr/src/linux-2.6.37.3/drivers/net/wireless/zd1211rw/zd_usb.c	2011-03-12 10:21:48.261473001 +0200
> @@ -59,6 +59,7 @@
>  	{ USB_DEVICE(0x157e, 0x300a), .driver_info = DEVICE_ZD1211 },
>  	{ USB_DEVICE(0x157e, 0x300b), .driver_info = DEVICE_ZD1211 },
>  	{ USB_DEVICE(0x157e, 0x3204), .driver_info = DEVICE_ZD1211 },
> +	{ USB_DEVICE(0x157e, 0x3207), .driver_info = DEVICE_ZD1211 },
>  	{ USB_DEVICE(0x1740, 0x2000), .driver_info = DEVICE_ZD1211 },
>  	{ USB_DEVICE(0x6891, 0xa727), .driver_info = DEVICE_ZD1211 },
>  	/* ZD1211B */


-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
