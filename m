Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37740 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab1DJRMR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 13:12:17 -0400
Received: by wya21 with SMTP id 21so4221964wya.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Apr 2011 10:12:16 -0700 (PDT)
Message-ID: <4DA1E4ED.6080804@gmail.com>
Date: Sun, 10 Apr 2011 19:12:13 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH] rt2800usb: Add three new USB IDs
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:

> There are three USB IDs supported by staging/rt2870sta that are not in the
> mainline driver rt2800usb.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>
> ---
> 
> Index: wireless-testing/drivers/net/wireless/rt2x00/rt2800usb.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ wireless-testing/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -758,6 +758,8 @@ static struct usb_device_id rt2800usb_de
>  	{ USB_DEVICE(0x07d1, 0x3c0f), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	{ USB_DEVICE(0x07d1, 0x3c11), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	{ USB_DEVICE(0x07d1, 0x3c16), USB_DEVICE_DATA(&rt2800usb_ops) },
> +	{ USB_DEVICE(0x2001, 0x3c09), USB_DEVICE_DATA(&rt2800usb_ops) },
> +	{ USB_DEVICE(0x2001, 0x3c0a), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	/* Draytek */
>  	{ USB_DEVICE(0x07fa, 0x7712), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	/* Edimax */
> @@ -828,6 +830,7 @@ static struct usb_device_id rt2800usb_de
>  	/* Planex */
>  	{ USB_DEVICE(0x2019, 0xab25), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	{ USB_DEVICE(0x2019, 0xed06), USB_DEVICE_DATA(&rt2800usb_ops) },
> +	{ USB_DEVICE(0x2019, 0xed14), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	/* Quanta */
>  	{ USB_DEVICE(0x1a32, 0x0304), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	/* Ralink */

NACK, unless they also be in the windows driver.
They were eliminated in recent versions of ralink LiNUX drivers.
