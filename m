Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:53366 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784Ab0EJJrj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 05:47:39 -0400
Received: by bwz19 with SMTP id 19so1629103bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 10 May 2010 02:47:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273484136-1969-1-git-send-email-xose.vazquez@gmail.com>
References: <1273484136-1969-1-git-send-email-xose.vazquez@gmail.com>
Date: Mon, 10 May 2010 11:47:37 +0200
Message-ID: <AANLkTimbeKNk9mqCN1Lnjt_AEijLeOUSEb4W5pQPnUtQ@mail.gmail.com>
Subject: Re: [PATCH] [PATCH 1/1] wireless: rt2x00: rt2800usb: replace X by x
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linville@tuxdriver.com, gwingerde@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 10, 2010 at 11:35 AM, Xose Vazquez Perez
<xose.vazquez@gmail.com> wrote:
> s/X/x
>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index e3f3a97..456d265 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -841,7 +841,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x7392, 0x7717), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x7392, 0x7718), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* EnGenius */
> -       { USB_DEVICE(0X1740, 0x9701), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       { USB_DEVICE(0x1740, 0x9701), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x1740, 0x9702), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Gigabyte */
>        { USB_DEVICE(0x1044, 0x800b), USB_DEVICE_DATA(&rt2800usb_ops) },
> --
> 1.6.6.1
>
>
