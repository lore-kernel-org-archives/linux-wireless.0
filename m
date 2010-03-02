Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:62230 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752499Ab0CBHXH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 02:23:07 -0500
Message-ID: <4B8CBCD2.9020203@gmail.com>
Date: Tue, 02 Mar 2010 08:22:58 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Bryan Polk <sainth@eidolons.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>
Subject: Re: [PATCH] rt2x00: Add USB ID for CEIVA adapter to rt73usb
References: <51a465a61002281248jc7701abq642b67f0b68ed80a@mail.gmail.com> <4B8B3A1A.80403@gmail.com> <alpine.LNX.2.00.1003011205211.28884@eidolons.org>
In-Reply-To: <alpine.LNX.2.00.1003011205211.28884@eidolons.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/01/10 18:23, Bryan Polk wrote:
> This adds support for CEIVA USB wireless adapters to the rt73usb driver.
> 
> Signed-off-by: Bryan Polk <sainth@eidolons.org>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
> index f39a8ed..47f3e4a 100644
> --- a/drivers/net/wireless/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/rt2x00/rt73usb.c
> @@ -2352,6 +2352,8 @@ static struct usb_device_id rt73usb_device_table[] = {
>  	{ USB_DEVICE(0x0411, 0x00f4), USB_DEVICE_DATA(&rt73usb_ops) },
>  	{ USB_DEVICE(0x0411, 0x0116), USB_DEVICE_DATA(&rt73usb_ops) },
>  	{ USB_DEVICE(0x0411, 0x0119), USB_DEVICE_DATA(&rt73usb_ops) },
> +	/* CEIVA */
> +	{ USB_DEVICE(0x178d, 0x02be), USB_DEVICE_DATA(&rt73usb_ops) },
>  	/* CNet */
>  	{ USB_DEVICE(0x1371, 0x9022), USB_DEVICE_DATA(&rt73usb_ops) },
>  	{ USB_DEVICE(0x1371, 0x9032), USB_DEVICE_DATA(&rt73usb_ops) },
> 

