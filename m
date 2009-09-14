Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:20197 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757425AbZINWbP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 18:31:15 -0400
Received: by ey-out-2122.google.com with SMTP id 25so683102eya.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 15:31:18 -0700 (PDT)
Message-ID: <4AAEC2A5.9030009@lwfinger.net>
Date: Mon, 14 Sep 2009 17:24:37 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Jari Jaakola <jari.jaakola@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>, stable@kernel.org
Subject: Re: [PATCH] p54usb: add Zcomax XG-705A usbid
References: <6c9000d40909141238w2331a975tdaf0952487a3c76@mail.gmail.com> <200909142308.43652.chunkeey@googlemail.com>
In-Reply-To: <200909142308.43652.chunkeey@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> This patch adds a new usbid for Zcomax XG-705A to the device table.
> 
> Cc: stable@kernel.org
> Reported-by: Jari Jaakola <jari.jaakola@gmail.com>
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
> diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
> index e44460f..17e1995 100644
> --- a/drivers/net/wireless/p54/p54usb.c
> +++ b/drivers/net/wireless/p54/p54usb.c
> @@ -67,6 +67,7 @@ static struct usb_device_id p54u_table[] __devinitdata = {
>  	{USB_DEVICE(0x0bf8, 0x1009)},   /* FUJITSU E-5400 USB D1700*/
>  	{USB_DEVICE(0x0cde, 0x0006)},   /* Medion MD40900 */
>  	{USB_DEVICE(0x0cde, 0x0008)},	/* Sagem XG703A */
> +	{USB_DEVICE(0x0cde, 0x0015)},	/* Zcomax XG-705A */
>  	{USB_DEVICE(0x0d8e, 0x3762)},	/* DLink DWL-G120 Cohiba */
>  	{USB_DEVICE(0x124a, 0x4025)},	/* IOGear GWU513 (GW3887IK chip) */
>  	{USB_DEVICE(0x1260, 0xee22)},	/* SMC 2862W-G version 2 */
> --

ack
