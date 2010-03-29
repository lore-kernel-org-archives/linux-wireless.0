Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f222.google.com ([209.85.219.222]:63146 "EHLO
	mail-ew0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab0C2KaW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 06:30:22 -0400
Received: by ewy22 with SMTP id 22so1763369ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 03:30:20 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 2/2] wireless: rt2x00: rt2800usb: delete id
Date: Mon, 29 Mar 2010 11:30:18 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linville@tuxdriver.com
References: <1269788252-7473-1-git-send-email-xose.vazquez@gmail.com>
In-Reply-To: <1269788252-7473-1-git-send-email-xose.vazquez@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <201003291230.18379.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 28 March 2010, Xose Vazquez Perez wrote:
> It was removed in the windows inf file by ralink.
> And it isn't on ralink linux drivers.
> 
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index a1691b8..c1cc15d 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -1010,8 +1010,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
>  	/* Amigo */
>  	{ USB_DEVICE(0x0e0b, 0x9031), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	{ USB_DEVICE(0x0e0b, 0x9041), USB_DEVICE_DATA(&rt2800usb_ops) },
> -	/* Askey */
> -	{ USB_DEVICE(0x0930, 0x0a07), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	/* ASUS */
>  	{ USB_DEVICE(0x0b05, 0x1760), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	{ USB_DEVICE(0x0b05, 0x1761), USB_DEVICE_DATA(&rt2800usb_ops) },


