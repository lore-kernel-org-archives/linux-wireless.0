Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59680 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2BLP3G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Feb 2012 10:29:06 -0500
MIME-Version: 1.0
In-Reply-To: <1328993889-28763-1-git-send-email-gwingerde@gmail.com>
References: <1328993889-28763-1-git-send-email-gwingerde@gmail.com>
Date: Sun, 12 Feb 2012 16:29:05 +0100
Message-ID: <CAOZOX0WD_EZc9gU11jq_3v-bYDWqset--1MLHy-MUSAYxgafUg@mail.gmail.com> (sfid-20120212_162933_871141_AE9476BC)
Subject: Re: [PATCH] rt2x00: Add support for D-Link DWA-127 to rt2800usb.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 11, 2012 at 9:58 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> This is an RT3070 based device.
>
> Cc: <stable@vger.kernel.org>
> Reported-by: Mikhail Kryshen <mikhail@kryshen.net>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index d009b6b..0074c4e 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -921,6 +921,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x07d1, 0x3c13) },
>        { USB_DEVICE(0x07d1, 0x3c15) },
>        { USB_DEVICE(0x07d1, 0x3c16) },
> +       { USB_DEVICE(0x2001, 0x3c1b) },
>        /* Draytek */
>        { USB_DEVICE(0x07fa, 0x7712) },
>        /* DVICO */
> --
> 1.7.9
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
