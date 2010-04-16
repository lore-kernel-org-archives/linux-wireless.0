Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:34765 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab0DPLRL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 07:17:11 -0400
Received: by bwz25 with SMTP id 25so2929979bwz.28
        for <linux-wireless@vger.kernel.org>; Fri, 16 Apr 2010 04:17:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1271413005-2509-1-git-send-email-xose.vazquez@gmail.com>
References: <1271413005-2509-1-git-send-email-xose.vazquez@gmail.com>
Date: Fri, 16 Apr 2010 13:17:07 +0200
Message-ID: <u2ja32f33a41004160417jfcf1db3bw62d464405fead085@mail.gmail.com>
Subject: Re: [PATCH] wireless: rt2x00: rt2800usb: delete Allwin devices
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linville@tuxdriver.com, gwingerde@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 16, 2010 at 12:16 PM, Xose Vazquez Perez
<xose.vazquez@gmail.com> wrote:
> Common sense says:
> (0x8516, 0x2070) is RT2070
> (0x8516, 0x2770) is RT2770
> (0x8516, 0x2870) is RT2870
> [...]
>
> but Allwin doesn't sell USB dongles nor PCI boards, only voip-routers
> http://www.allwin.com.tw/eng/modules/tinyd0/content/index.php?id=1

But how about the case where the company name is wrong and the ID's are valid?
That means we only should update the comment, rather then deleting the ID's.

> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index df7666f..41de405 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -1019,14 +1019,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
>         * Unclear what kind of devices these are (they aren't supported by the
>         * vendor driver).
>         */
> -       /* Allwin */
> -       { USB_DEVICE(0x8516, 0x2070), USB_DEVICE_DATA(&rt2800usb_ops) },
> -       { USB_DEVICE(0x8516, 0x2770), USB_DEVICE_DATA(&rt2800usb_ops) },
> -       { USB_DEVICE(0x8516, 0x2870), USB_DEVICE_DATA(&rt2800usb_ops) },
> -       { USB_DEVICE(0x8516, 0x3070), USB_DEVICE_DATA(&rt2800usb_ops) },
> -       { USB_DEVICE(0x8516, 0x3071), USB_DEVICE_DATA(&rt2800usb_ops) },
> -       { USB_DEVICE(0x8516, 0x3072), USB_DEVICE_DATA(&rt2800usb_ops) },
> -       { USB_DEVICE(0x8516, 0x3572), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Amigo */
>        { USB_DEVICE(0x0e0b, 0x9031), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x0e0b, 0x9041), USB_DEVICE_DATA(&rt2800usb_ops) },
> --
> 1.6.6.1
>
>
