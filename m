Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63073 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932772AbaHEJDS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2014 05:03:18 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so634977wgh.27
        for <linux-wireless@vger.kernel.org>; Tue, 05 Aug 2014 02:03:13 -0700 (PDT)
Message-ID: <53E09DCC.4020208@gmail.com> (sfid-20140805_110321_980269_11B49BAA)
Date: Tue, 05 Aug 2014 11:03:08 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH] wireless: rt2x00: add new rt2800usb devices
References: <1405108017-9634-1-git-send-email-xose.vazquez@gmail.com>
In-Reply-To: <1405108017-9634-1-git-send-email-xose.vazquez@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/11/2014 09:46 PM, Xose Vazquez Perez wrote:

> 0x0b05 0x17e8 RT5372 USB 2.0  bgn 2x2 ASUS USB-N14
> 0x0411 0x0253 RT5572 USB 2.0 abgn 2x2 BUFFALO WLP-U2-300D
> 0x0df6 0x0078 RT???? Sitecom N300
> 
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Helmut Schaa <helmut.schaa@googlemail.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: users@rt2x00.serialmonkey.com
> Cc: linux-wireless@vger.kernel.org
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 832006b..573897b 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -1284,6 +1284,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
>  	/* Arcadyan */
>  	{ USB_DEVICE(0x043e, 0x7a12) },
>  	{ USB_DEVICE(0x043e, 0x7a32) },
> +	/* ASUS */
> +	{ USB_DEVICE(0x0b05, 0x17e8) },
>  	/* Azurewave */
>  	{ USB_DEVICE(0x13d3, 0x3329) },
>  	{ USB_DEVICE(0x13d3, 0x3365) },
> @@ -1320,6 +1322,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>  	{ USB_DEVICE(0x057c, 0x8501) },
>  	/* Buffalo */
>  	{ USB_DEVICE(0x0411, 0x0241) },
> +	{ USB_DEVICE(0x0411, 0x0253) },
>  	/* D-Link */
>  	{ USB_DEVICE(0x2001, 0x3c1a) },
>  	{ USB_DEVICE(0x2001, 0x3c21) },
> @@ -1410,6 +1413,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>  	{ USB_DEVICE(0x0df6, 0x0053) },
>  	{ USB_DEVICE(0x0df6, 0x0069) },
>  	{ USB_DEVICE(0x0df6, 0x006f) },
> +	{ USB_DEVICE(0x0df6, 0x0078) },
>  	/* SMC */
>  	{ USB_DEVICE(0x083a, 0xa512) },
>  	{ USB_DEVICE(0x083a, 0xc522) },
> 

John,

Could you send it to -stable ?

-thanks-
