Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:48749 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab0BKDGa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Feb 2010 22:06:30 -0500
Received: by ewy28 with SMTP id 28so895048ewy.28
        for <linux-wireless@vger.kernel.org>; Wed, 10 Feb 2010 19:06:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4b72d1f1.J9VQrXuO+0LD2CFM%Larry.Finger@lwfinger.net>
References: <4b72d1f1.J9VQrXuO+0LD2CFM%Larry.Finger@lwfinger.net>
Date: Thu, 11 Feb 2010 03:06:27 +0000
Message-ID: <3ace41891002101906l641c7a84n4669b3af2dcdeeb8@mail.gmail.com>
Subject: Re: [PATCH] rtl8187: Add new device ID
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>, jmkok@solutionsradio.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 10, 2010 at 3:34 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> From: Jelle Martijn Kok <jmkok@solutionsradio.com>
>
> Add new RTL8187B device.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@kernel.org>

Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

It looks obviously enough to be a newer version of an old supported
device - Some info about what device it is, etc in the check-in
message would be nice, but this can go in as is.

> ---
>
>
> Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
> +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
> @@ -65,6 +65,7 @@ static struct usb_device_id rtl8187_tabl
>        /* Sitecom */
>        {USB_DEVICE(0x0df6, 0x000d), .driver_info = DEVICE_RTL8187},
>        {USB_DEVICE(0x0df6, 0x0028), .driver_info = DEVICE_RTL8187B},
> +       {USB_DEVICE(0x0df6, 0x0029), .driver_info = DEVICE_RTL8187B},
>        /* Sphairon Access Systems GmbH */
>        {USB_DEVICE(0x114B, 0x0150), .driver_info = DEVICE_RTL8187},
>        /* Dick Smith Electronics */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
