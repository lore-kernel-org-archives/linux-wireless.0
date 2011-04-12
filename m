Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46260 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240Ab1DLCtA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 22:49:00 -0400
Date: Mon, 11 Apr 2011 22:42:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Mark Davis <marked86@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	IvDoorn@gmail.com, gwingerde@gmail.com, helmut.schaa@googlemail.com
Subject: Re: [PATCH] rt2800usb: Add seven new USB IDs
Message-ID: <20110412024240.GA10279@tuxdriver.com>
References: <BANLkTinFSTmCky-xm-3sMUU8pcjSjy2D-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <BANLkTinFSTmCky-xm-3sMUU8pcjSjy2D-A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 11, 2011 at 10:38:34PM -0400, Mark Davis wrote:
> Adds USB IDs for seven previously missing devices. Additionally, all
> instances of 'Conceptronic' have been replaced by the OEM name.
> 
> Devices added are..
> 0411:01a2 - Buffalo WLI-UC-GNM, RT3070V
> 0586:341e - ZyXEL NWD2105, RT3070
> 13b1:002f - Linksys AE1000, RT3572
> 13b1:0031 - Cisco / Linksys AM10, RT3072
> 14b2:3c2c - Keebox W150NU / Alpha Networks WUS-N12, RT3070
> 157e:3013 - TRENDnet TEW-645UB, RT2770+RT2720
> 15a9:0012 - Airlink AWLL7025 / Gemtek WUBR-208N, RT2870+RT2850
> 
> Signed-off-by: Mark Davis <marked86@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |   35 +++++++++++++++++++-----------
>  1 files changed, 22 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c
> b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 6ba31a0..db52c2b 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -710,6 +710,16 @@ static struct usb_device_id rt2800usb_device_table[] = {
>  	{ USB_DEVICE(0x8516, 0x3070), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	{ USB_DEVICE(0x8516, 0x3071), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	{ USB_DEVICE(0x8516, 0x3072), USB_DEVICE_DATA(&rt2800usb_ops) },
> +	/* Alpha Networks */
> +        { USB_DEVICE(0x14b2, 0x3c06), USB_DEVICE_DATA(&rt2800usb_ops) },
> +        { USB_DEVICE(0x14b2, 0x3c07), USB_DEVICE_DATA(&rt2800usb_ops) },
> +        { USB_DEVICE(0x14b2, 0x3c09), USB_DEVICE_DATA(&rt2800usb_ops) },
> +        { USB_DEVICE(0x14b2, 0x3c12), USB_DEVICE_DATA(&rt2800usb_ops) },
> +        { USB_DEVICE(0x14b2, 0x3c23), USB_DEVICE_DATA(&rt2800usb_ops) },

Please use tabs...

-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
