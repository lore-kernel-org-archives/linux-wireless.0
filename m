Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39589 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab0FEUaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jun 2010 16:30:25 -0400
Received: by fxm8 with SMTP id 8so1384452fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jun 2010 13:30:24 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] p54usb: Add device ID for Dell WLA3310 USB
Date: Sat, 5 Jun 2010 22:30:18 +0200
Cc: John W Linville <linville@tuxdriver.com>, dravet@hotmail.com,
	linux-wireless@vger.kernel.org
References: <4c0aaebd.7lqiusTk9vdkgjCd%Larry.Finger@lwfinger.net>
In-Reply-To: <4c0aaebd.7lqiusTk9vdkgjCd%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006052230.18402.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 05 June 2010 22:08:29 Larry Finger wrote:
> From: Jason Dravet <dravet@hotmail.com>
> 
> Add Dell WLA3310 USB wireless card, which is based on
> Z-Com XG-705A and has an ISL3887 chipset, to the USB Ids
> in p54usb.
> 
> Signed-off-by: Jason Dravet <dravet@hotmail.com>
> Tested-by: Richard Gregory Tillmore <rtillmore@gmail.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>
Cc: <stable@kernel.org>

> ---
> 
> Index: wireless-testing/drivers/net/wireless/p54/p54usb.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/p54/p54usb.c
> +++ wireless-testing/drivers/net/wireless/p54/p54usb.c
> @@ -80,6 +80,7 @@ static struct usb_device_id p54u_table[]
>  	{USB_DEVICE(0x1413, 0x5400)},   /* Telsey 802.11g USB2.0 Adapter */
>  	{USB_DEVICE(0x1435, 0x0427)},	/* Inventel UR054G */
>  	{USB_DEVICE(0x2001, 0x3704)},	/* DLink DWL-G122 rev A2 */
> +	{USB_DEVICE(0x413c, 0x5513)},	/* Dell WLA3310 USB Wireless Adapter */
>  	{USB_DEVICE(0x413c, 0x8102)},	/* Spinnaker DUT */
>  	{USB_DEVICE(0x413c, 0x8104)},	/* Cohiba Proto board */
>  	{}
> 
