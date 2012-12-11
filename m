Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61271 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab2LKPV6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 10:21:58 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so2955546lbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2012 07:21:57 -0800 (PST)
Message-ID: <50C74F90.401@gmail.com> (sfid-20121211_162202_739159_33BD2CE9)
Date: Tue, 11 Dec 2012 16:21:52 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Maia Kozheva <sikon@ubuntu.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
Subject: Re: [PATCH v2] Add support for 2001:3c1e (D-Link DWA-125 rev B1)
 USB Wi-Fi adapter
References: <50C6974B.5000206@gmail.com> <50C6B8E0.4080801@ubuntu.com>
In-Reply-To: <50C6B8E0.4080801@ubuntu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/11/2012 05:38 AM, Maia Kozheva wrote:
> Someone who physically disassembled the device confirms that its chipset is Ralink RT5370n.
>
> Fixed the patch.
>
> Signed-off-by: Maia Kozheva <sikon@ubuntu.com>
> diff -uprN a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c	2012-11-28 04:21:31.000000000 +0700
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c	2012-12-11 11:34:35.889131671 +0700
> @@ -1169,6 +1169,7 @@ static struct usb_device_id rt2800usb_de
>   	{ USB_DEVICE(0x2001, 0x3c19) },
>   	{ USB_DEVICE(0x2001, 0x3c1c) },
>   	{ USB_DEVICE(0x2001, 0x3c1d) },
> +	{ USB_DEVICE(0x2001, 0x3c1e) },
>   	/* LG innotek */
>   	{ USB_DEVICE(0x043e, 0x7a22) },
>   	/* Panasonic */
>
>

Reviewed-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
