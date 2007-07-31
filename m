Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:25954 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760034AbXGaMIh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 08:08:37 -0400
Received: by fk-out-0910.google.com with SMTP id z23so392946fkz
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 05:08:35 -0700 (PDT)
To: warmcat <andy@warmcat.com>
Subject: Re: [PATCH] rt73usb-add-bluenext-148f-2573
Date: Tue, 31 Jul 2007 14:12:29 +0200
Cc: linux-wireless@vger.kernel.org
References: <20070731115446.5717.37617.stgit@localhost>
In-Reply-To: <20070731115446.5717.37617.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707311412.30340.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 31 July 2007, warmcat wrote:
> Add device ID for cheapo BlueNext rt2571-based stick BN-WD54G
> 
> Signed-off-by: Andy Green <andy@warmcat.com>
> ---
>
>  drivers/net/wireless/rt73usb.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
> index 3d838d1..82bb23c 100644
> --- a/drivers/net/wireless/rt73usb.c
> +++ b/drivers/net/wireless/rt73usb.c
> @@ -1814,6 +1814,8 @@ static struct usb_device_id rt73usb_device_table[] = {
>  	{ USB_DEVICE(0x050d, 0x905b), USB_DEVICE_DATA(&rt73usb_ops) },
>  	/* Billionton */
>  	{ USB_DEVICE(0x1631, 0xc019), USB_DEVICE_DATA(&rt73usb_ops) },
> +	/* BlueNEXT */
> +	{ USB_DEVICE(0x148f, 0x2573), USB_DEVICE_DATA(&rt73usb_ops) },

This USB ID is already in the List under the Label "Ralink"

	/* Ralink */
	{ USB_DEVICE(0x148f, 0x2573), USB_DEVICE_DATA(&rt73usb_ops) },

Ivo

