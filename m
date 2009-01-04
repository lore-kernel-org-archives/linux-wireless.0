Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:48310 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbZADIyI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 03:54:08 -0500
Received: by ewy10 with SMTP id 10so7380623ewy.13
        for <linux-wireless@vger.kernel.org>; Sun, 04 Jan 2009 00:54:04 -0800 (PST)
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Subject: Re: [PATCH] rt2x00: add USB ID for the Linksys WUSB200.
Date: Sun, 4 Jan 2009 09:54:01 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200901040110.51629.s.L-H@gmx.de>
In-Reply-To: <200901040110.51629.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901040954.02065.IvDoorn@gmail.com> (sfid-20090104_095413_823907_4808AF47)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 04 January 2009, Stefan Lippers-Hollmann wrote:
> add USB ID for the Linksys WUSB200 Wireless-G Business USB Adapter to 
> rt73usb.
> 
> Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
> Cc: stable <stable@kernel.org>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt73usb.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
> index d638a8a..96a8d69 100644
> --- a/drivers/net/wireless/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/rt2x00/rt73usb.c
> @@ -2321,6 +2321,7 @@ static struct usb_device_id rt73usb_device_table[] = {
>  	/* Linksys */
>  	{ USB_DEVICE(0x13b1, 0x0020), USB_DEVICE_DATA(&rt73usb_ops) },
>  	{ USB_DEVICE(0x13b1, 0x0023), USB_DEVICE_DATA(&rt73usb_ops) },
> +	{ USB_DEVICE(0x13b1, 0x0028), USB_DEVICE_DATA(&rt73usb_ops) },
>  	/* MSI */
>  	{ USB_DEVICE(0x0db0, 0x6877), USB_DEVICE_DATA(&rt73usb_ops) },
>  	{ USB_DEVICE(0x0db0, 0x6874), USB_DEVICE_DATA(&rt73usb_ops) },


