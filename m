Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44342 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756890Ab1DLKqC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 06:46:02 -0400
Received: by qyk7 with SMTP id 7so1883251qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 03:46:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4da3e0e7.OIpXziberWyLiFw6%Larry.Finger@lwfinger.net>
References: <4da3e0e7.OIpXziberWyLiFw6%Larry.Finger@lwfinger.net>
Date: Tue, 12 Apr 2011 12:46:01 +0200
Message-ID: <BANLkTikYCe0kyg9AD3jBgTAhFjZy1-mG-Q@mail.gmail.com>
Subject: Re: [PATCH v2] rt2800usb: Add seven new USB IDs
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>, marked86@gmail.com,
	helmut.schaa@googlemail.com, IvDoorn@gmail.com,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 12, 2011 at 7:19 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> From: Mark Davis <marked86@gmail.com>
>
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
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>
> V1 => V2 Change spaces to tabs.
>
>  drivers/net/wireless/rt2x00/rt2800usb.c |   35 +++++++++++++++++++-----------
>  1 files changed, 22 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c
> b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 6ba31a0..d2f5c87 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -710,6 +710,16 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x8516, 0x3070), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x8516, 0x3071), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x8516, 0x3072), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       /* Alpha Networks */
> +       { USB_DEVICE(0x14b2, 0x3c06), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       { USB_DEVICE(0x14b2, 0x3c07), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       { USB_DEVICE(0x14b2, 0x3c09), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       { USB_DEVICE(0x14b2, 0x3c12), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       { USB_DEVICE(0x14b2, 0x3c23), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       { USB_DEVICE(0x14b2, 0x3c25), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       { USB_DEVICE(0x14b2, 0x3c27), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       { USB_DEVICE(0x14b2, 0x3c28), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       { USB_DEVICE(0x14b2, 0x3c2c), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Amit */
>        { USB_DEVICE(0x15c5, 0x0008), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Askey */
> @@ -736,15 +746,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        /* Buffalo */
>        { USB_DEVICE(0x0411, 0x00e8), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x0411, 0x016f), USB_DEVICE_DATA(&rt2800usb_ops) },
> -       /* Conceptronic */
> -       { USB_DEVICE(0x14b2, 0x3c06), USB_DEVICE_DATA(&rt2800usb_ops) },
> -       { USB_DEVICE(0x14b2, 0x3c07), USB_DEVICE_DATA(&rt2800usb_ops) },
> -       { USB_DEVICE(0x14b2, 0x3c09), USB_DEVICE_DATA(&rt2800usb_ops) },
> -       { USB_DEVICE(0x14b2, 0x3c12), USB_DEVICE_DATA(&rt2800usb_ops) },
> -       { USB_DEVICE(0x14b2, 0x3c23), USB_DEVICE_DATA(&rt2800usb_ops) },
> -       { USB_DEVICE(0x14b2, 0x3c25), USB_DEVICE_DATA(&rt2800usb_ops) },
> -       { USB_DEVICE(0x14b2, 0x3c27), USB_DEVICE_DATA(&rt2800usb_ops) },
> -       { USB_DEVICE(0x14b2, 0x3c28), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       { USB_DEVICE(0x0411, 0x01a2), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Corega */
>        { USB_DEVICE(0x07aa, 0x002f), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x07aa, 0x003c), USB_DEVICE_DATA(&rt2800usb_ops) },
> @@ -776,6 +778,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x1740, 0x9707), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x1740, 0x9708), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x1740, 0x9709), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       /* Gemtek */
> +       { USB_DEVICE(0x15a9, 0x0012), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Gigabyte */
>        { USB_DEVICE(0x1044, 0x800b), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x1044, 0x800d), USB_DEVICE_DATA(&rt2800usb_ops) },
> @@ -792,6 +796,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x04bb, 0x0947), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x04bb, 0x0948), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Linksys */
> +       { USB_DEVICE(0x13b1, 0x0031), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x1737, 0x0070), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x1737, 0x0071), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Logitec */
> @@ -870,8 +875,9 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x15a9, 0x0006), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Sweex */
>        { USB_DEVICE(0x177f, 0x0302), USB_DEVICE_DATA(&rt2800usb_ops) },
> -       /* U-Media*/
> +       /* U-Media */
>        { USB_DEVICE(0x157e, 0x300e), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       { USB_DEVICE(0x157e, 0x3013), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* ZCOM */
>        { USB_DEVICE(0x0cde, 0x0022), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x0cde, 0x0025), USB_DEVICE_DATA(&rt2800usb_ops) },
> @@ -883,6 +889,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        /* Zyxel */
>        { USB_DEVICE(0x0586, 0x3416), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x0586, 0x3418), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       { USB_DEVICE(0x0586, 0x341e), USB_DEVICE_DATA(&rt2800usb_ops) },
>  #ifdef CONFIG_RT2800USB_RT33XX
>        /* Ralink */
>        { USB_DEVICE(0x148f, 0x3370), USB_DEVICE_DATA(&rt2800usb_ops) },
> @@ -901,6 +908,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x1740, 0x9801), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* I-O DATA */
>        { USB_DEVICE(0x04bb, 0x0944), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       /* Linksys */
> +       { USB_DEVICE(0x13b1, 0x002f), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Ralink */
>        { USB_DEVICE(0x148f, 0x3572), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Sitecom */
> @@ -915,6 +924,9 @@ static struct usb_device_id rt2800usb_device_table[] = {
>         * Unclear what kind of devices these are (they aren't supported by the
>         * vendor linux driver).
>         */
> +       /* Alpha Networks */
> +       { USB_DEVICE(0x14b2, 0x3c08), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       { USB_DEVICE(0x14b2, 0x3c11), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Amigo */
>        { USB_DEVICE(0x0e0b, 0x9031), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x0e0b, 0x9041), USB_DEVICE_DATA(&rt2800usb_ops) },
> @@ -933,9 +945,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x0411, 0x0148), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x0411, 0x0150), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x0411, 0x015d), USB_DEVICE_DATA(&rt2800usb_ops) },
> -       /* Conceptronic */
> -       { USB_DEVICE(0x14b2, 0x3c08), USB_DEVICE_DATA(&rt2800usb_ops) },
> -       { USB_DEVICE(0x14b2, 0x3c11), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Corega */
>        { USB_DEVICE(0x07aa, 0x0041), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x07aa, 0x0042), USB_DEVICE_DATA(&rt2800usb_ops) },
>



-- 
---
Gertjan
