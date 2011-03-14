Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bounce-out.neti.ee ([194.126.101.104]:60314 "EHLO
	bounce-out.neti.ee" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab1CNTHo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 15:07:44 -0400
Received: from smtp-out.neti.ee (vm-relay8.estpak.ee [88.196.174.139])
	by Bounce1.estpak.ee (Postfix) with ESMTP id BEF893B936D
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 20:58:22 +0200 (EET)
Subject: Re: [PATCH] zd1211rw: TrendNet TEW-509UB id added
From: =?ISO-8859-1?Q?T=F5nu?= Samuel <tonu@jes.ee>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20110314185021.GB2525@tuxdriver.com>
References: <1299922165.3044.1.camel@hp>
	 <20110314185021.GB2525@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Mar 2011 20:57:36 +0200
Message-ID: <1300129056.15792.10.camel@hp>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-14 at 14:50 -0400, John W. Linville wrote:

> Missing a Signed-off-by line here...
> 
> 	http://linux.yyz.us/patch-format.html
> 

Fixed :)

> > --- ./drivers/net/wireless/zd1211rw/zd_usb.c	2011-03-08 01:05:50.000000000 +0200
> > +++ /usr/src/linux-2.6.37.3/drivers/net/wireless/zd1211rw/zd_usb.c	2011-03-12 10:21:48.261473001 +0200
> > @@ -59,6 +59,7 @@
> >  	{ USB_DEVICE(0x157e, 0x300a), .driver_info = DEVICE_ZD1211 },
> >  	{ USB_DEVICE(0x157e, 0x300b), .driver_info = DEVICE_ZD1211 },
> >  	{ USB_DEVICE(0x157e, 0x3204), .driver_info = DEVICE_ZD1211 },
> > +	{ USB_DEVICE(0x157e, 0x3207), .driver_info = DEVICE_ZD1211 },
> >  	{ USB_DEVICE(0x1740, 0x2000), .driver_info = DEVICE_ZD1211 },
> >  	{ USB_DEVICE(0x6891, 0xa727), .driver_info = DEVICE_ZD1211 },
> >  	/* ZD1211B */
> 
> 


Signed-off-by: Tõnu Samuel <tonu@jes.ee>

