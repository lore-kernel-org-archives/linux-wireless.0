Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:64641 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab1HEHgw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2011 03:36:52 -0400
Received: by iye16 with SMTP id 16so3170699iye.1
        for <linux-wireless@vger.kernel.org>; Fri, 05 Aug 2011 00:36:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1312523195.1413.8.camel@moss>
References: <1312523195.1413.8.camel@moss>
Date: Fri, 5 Aug 2011 09:31:35 +0200
Message-ID: <CAOZOX0Xohg6Zy00UrOzXGSfNUZ7TiOtOOa_BSfR+-Vhy=wfdZQ@mail.gmail.com> (sfid-20110805_093655_646443_E709607C)
Subject: Re: [PATCH] rt2x00: Add rt2870 device id for Dvico usb key
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Anthony Bourguignon <contact+kernel@toniob.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 5, 2011 at 7:46 AM, Anthony Bourguignon
<contact+kernel@toniob.net> wrote:
> This patch add a device id for the wifi usb keys shiped by DVICO with some of their tvix hardware.
> Signed-off-by: Anthony Bourguignon <contact+kernel@toniob.net>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>
> --- linux-3.0/drivers/net/wireless/rt2x00/rt2800usb.c.orig      2011-08-05 07:33:06.358681019 +0200
> +++ linux-3.0/drivers/net/wireless/rt2x00/rt2800usb.c   2011-08-05 07:35:35.544225182 +0200
> @@ -839,6 +839,8 @@ static struct usb_device_id rt2800usb_de
>        { USB_DEVICE(0x07d1, 0x3c16) },
>        /* Draytek */
>        { USB_DEVICE(0x07fa, 0x7712) },
> +       /* DVICO */
> +       { USB_DEVICE(0x0fe9, 0xb307) },
>        /* Edimax */
>        { USB_DEVICE(0x7392, 0x7711) },
>        { USB_DEVICE(0x7392, 0x7717) },
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
