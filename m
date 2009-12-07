Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34007 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964982AbZLGWAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 17:00:19 -0500
Date: Mon, 7 Dec 2009 16:59:03 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Shahar Or <mightyiampresence@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	me@bobcopeland.com
Subject: Re: [PATCH] ath5k: add support for Dell Vostro A860 LED
Message-ID: <20091207215903.GC18939@tuxdriver.com>
References: <bf87febf0912030507u1c36f6a9h7cac0efabf3d016@mail.gmail.com> <20091204192315.GA5786@tuxdriver.com> <bf87febf0912070205k40a7286dpbb48cfcc494203d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <bf87febf0912070205k40a7286dpbb48cfcc494203d2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 07, 2009 at 12:05:54PM +0200, Shahar Or wrote:
> Adds support for the WiFi activity LED on the Dell Vostro A860 laptop.
> 
> Signed-off-by: Shahar Or <shahar@shahar-or.co.il>
> ---
> I hope this one is perfect.

Well, no, it was still quite whitespace damaged.  However this time
I was able to fix it manually and move on with life... :-)

> --- drivers/net/wireless/ath/ath5k/led.c.orig	2009-12-03
> 14:57:20.000000000 +0200
> +++ drivers/net/wireless/ath/ath5k/led.c	2009-12-03 14:25:30.000000000 +0200
> @@ -71,6 +71,8 @@
>  	{ ATH_SDEVICE(PCI_VENDOR_ID_IBM, 0x058a), ATH_LED(1, 0) },
>  	/* IBM-specific AR5212 (all others) */
>  	{ PCI_VDEVICE(ATHEROS, PCI_DEVICE_ID_ATHEROS_AR5212_IBM), ATH_LED(0, 0) },
> +	/* Dell Vostro A860 (shahar@shahar-or.co.il) */
> +	{ ATH_SDEVICE(PCI_VENDOR_ID_QMI, 0x0112), ATH_LED(3, 0) },
>  	{ }
>  };
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
