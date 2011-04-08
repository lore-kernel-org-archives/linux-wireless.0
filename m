Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61006 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab1DHOY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 10:24:57 -0400
Received: by qyk7 with SMTP id 7so4005123qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Apr 2011 07:24:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4d9f1a7c.6indLlUpd9nUfsN8%Larry.Finger@lwfinger.net>
References: <4d9f1a7c.6indLlUpd9nUfsN8%Larry.Finger@lwfinger.net>
Date: Fri, 8 Apr 2011 16:24:56 +0200
Message-ID: <BANLkTikcz13vgsLRs3qLYWui41No0rkvJw@mail.gmail.com>
Subject: Re: [PATCH] rt2800usb: Add three new USB IDs
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>, gwingerde@gmail.com,
	helmut.schaa@googlemail.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 8, 2011 at 4:23 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> There are three USB IDs supported by staging/rt2870sta that are not in the
> mainline driver rt2800usb.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>
> Index: wireless-testing/drivers/net/wireless/rt2x00/rt2800usb.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ wireless-testing/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -758,6 +758,8 @@ static struct usb_device_id rt2800usb_de
>        { USB_DEVICE(0x07d1, 0x3c0f), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x07d1, 0x3c11), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x07d1, 0x3c16), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       { USB_DEVICE(0x2001, 0x3c09), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       { USB_DEVICE(0x2001, 0x3c0a), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Draytek */
>        { USB_DEVICE(0x07fa, 0x7712), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Edimax */
> @@ -828,6 +830,7 @@ static struct usb_device_id rt2800usb_de
>        /* Planex */
>        { USB_DEVICE(0x2019, 0xab25), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x2019, 0xed06), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       { USB_DEVICE(0x2019, 0xed14), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Quanta */
>        { USB_DEVICE(0x1a32, 0x0304), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Ralink */
>
