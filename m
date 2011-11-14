Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46434 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab1KNOoz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 09:44:55 -0500
Received: by mail-vx0-f174.google.com with SMTP id gb30so525137vcb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2011 06:44:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321121444-31528-1-git-send-email-gwingerde@gmail.com>
References: <1321121444-31528-1-git-send-email-gwingerde@gmail.com>
Date: Mon, 14 Nov 2011 15:44:54 +0100
Message-ID: <CAOZOX0UUE5J9q7cv8161fi-SMDU+trws3wXeKrhgHVZU1k4LZQ@mail.gmail.com> (sfid-20111114_154458_428280_B60FE2D5)
Subject: Re: [rt2x00-users] [PATCH] rt2x00: Add USB device ID of Buffalo WLI-UC-GNHP.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 12, 2011 at 7:10 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> This is reported to be an RT3070 based device.
>
> Reported-by: Teika Kazura <teika@lavabit.com>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index f156579..3778763 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -919,6 +919,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x050d, 0x935b) },
>        /* Buffalo */
>        { USB_DEVICE(0x0411, 0x00e8) },
> +       { USB_DEVICE(0x0411, 0x0158) },
>        { USB_DEVICE(0x0411, 0x016f) },
>        { USB_DEVICE(0x0411, 0x01a2) },
>        /* Corega */
> --
> 1.7.7
>
>
> _______________________________________________
> users mailing list
> users@rt2x00.serialmonkey.com
> http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com
>
