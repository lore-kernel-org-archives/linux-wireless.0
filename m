Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50405 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbZLWIPd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 03:15:33 -0500
Received: by ewy19 with SMTP id 19so6063598ewy.21
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2009 00:15:32 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 1/5] rt2x00: Add USB ID for Linksys WUSB 600N rev 2.
Date: Wed, 23 Dec 2009 09:15:28 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1261523005-5856-1-git-send-email-gwingerde@gmail.com> <1261523005-5856-2-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1261523005-5856-2-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200912230915.29101.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 December 2009, Gertjan van Wingerde wrote:
> This is a rt2870 based device.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 40295b4..aff984b 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -933,6 +933,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>  	{ USB_DEVICE(0x1737, 0x0070), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	{ USB_DEVICE(0x1737, 0x0071), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	{ USB_DEVICE(0x1737, 0x0077), USB_DEVICE_DATA(&rt2800usb_ops) },
> +	{ USB_DEVICE(0x1737, 0x0079), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	/* Logitec */
>  	{ USB_DEVICE(0x0789, 0x0162), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	{ USB_DEVICE(0x0789, 0x0163), USB_DEVICE_DATA(&rt2800usb_ops) },


