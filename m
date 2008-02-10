Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:51125 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbYBJKbk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 05:31:40 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH] rt2x00: Add new USB ID to rt2500usb
Date: Sun, 10 Feb 2008 11:31:13 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200802101121.58058.IvDoorn@gmail.com>
In-Reply-To: <200802101121.58058.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802101131.13974.mb@bu3sch.de> (sfid-20080210_103143_220935_4896A065)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 10 February 2008 11:21:57 Ivo van Doorn wrote:
> 
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> ---
> John, please send this patch to the 2.6.24/2.6.25 stable trees.
> It is already present in the wireless-2.6 tree queued for 2.6.26.
> 
>  drivers/net/wireless/rt2x00/rt2500usb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
> index cba7f57..c4a6ab4 100644
> --- a/drivers/net/wireless/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
> @@ -1871,11 +1871,11 @@ static struct usb_device_id rt2500usb_device_table[] = {
>  	/* Hercules */
>  	{ USB_DEVICE(0x06f8, 0xe000), USB_DEVICE_DATA(&rt2500usb_ops) },
>  	/* Melco */
> +	{ USB_DEVICE(0x0411, 0x005e), USB_DEVICE_DATA(&rt2500usb_ops) },
>  	{ USB_DEVICE(0x0411, 0x0066), USB_DEVICE_DATA(&rt2500usb_ops) },
>  	{ USB_DEVICE(0x0411, 0x0067), USB_DEVICE_DATA(&rt2500usb_ops) },
>  	{ USB_DEVICE(0x0411, 0x008b), USB_DEVICE_DATA(&rt2500usb_ops) },
>  	{ USB_DEVICE(0x0411, 0x0097), USB_DEVICE_DATA(&rt2500usb_ops) },
> -
>  	/* MSI */
>  	{ USB_DEVICE(0x0db0, 0x6861), USB_DEVICE_DATA(&rt2500usb_ops) },
>  	{ USB_DEVICE(0x0db0, 0x6865), USB_DEVICE_DATA(&rt2500usb_ops) },

I'm unsure on how this is an actual _fix_ that we need in a stable kernel.
We always handled adding IDs as features.

-- 
Greetings Michael.
