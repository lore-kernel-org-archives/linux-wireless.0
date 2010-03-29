Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:62707 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab0C2WFG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 18:05:06 -0400
Received: by fxm23 with SMTP id 23so1268419fxm.21
        for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 15:05:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1269799361-12257-1-git-send-email-xose.vazquez@gmail.com>
References: <1269799361-12257-1-git-send-email-xose.vazquez@gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 30 Mar 2010 00:04:44 +0200
Message-ID: <69e28c911003291504r170c9941u3647f03ad5988b1@mail.gmail.com>
Subject: Re: [PATCH 4/4] wireless: rt2x00: rt2800usb: new ids
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linville@tuxdriver.com, IvDoorn@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 28, 2010 at 8:02 PM, Xose Vazquez Perez
<xose.vazquez@gmail.com> wrote:
> Taken from latest ralink linux driver(RT3070_LinuxSTA_V2.3.0.1_20100208)
> All of them are RT3070 devices.
>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index c1cc15d..03a85f7 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -910,6 +910,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        /* AzureWave */
>        { USB_DEVICE(0x13d3, 0x3273), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x13d3, 0x3305), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       { USB_DEVICE(0x13d3, 0x3307), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       { USB_DEVICE(0x13d3, 0x3321), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Conceptronic */
>        { USB_DEVICE(0x14b2, 0x3c12), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Corega */
> @@ -920,6 +922,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x07d1, 0x3c0e), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x07d1, 0x3c0f), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x07d1, 0x3c16), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       /* Draytek */
> +       { USB_DEVICE(0x07fa, 0x7712), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Edimax */
>        { USB_DEVICE(0x7392, 0x7711), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Encore */
> @@ -938,6 +942,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x04bb, 0x0945), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x04bb, 0x0947), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x04bb, 0x0948), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       /* Logitec */

Typo?

> +       { USB_DEVICE(0x0789, 0x0166), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* MSI */
>        { USB_DEVICE(0x0db0, 0x3820), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x0db0, 0x3821), USB_DEVICE_DATA(&rt2800usb_ops) },
> @@ -946,8 +952,12 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x0db0, 0x3871), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x0db0, 0x821a), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x0db0, 0x822a), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       { USB_DEVICE(0x0db0, 0x822b), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       { USB_DEVICE(0x0db0, 0x822c), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x0db0, 0x870a), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x0db0, 0x871a), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       { USB_DEVICE(0x0db0, 0x871b), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       { USB_DEVICE(0x0db0, 0x871c), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x0db0, 0x899a), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Para */
>        { USB_DEVICE(0x20b8, 0x8888), USB_DEVICE_DATA(&rt2800usb_ops) },
> @@ -972,6 +982,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x083a, 0x7511), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x083a, 0xa701), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x083a, 0xa702), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       { USB_DEVICE(0x083a, 0xa703), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* Zinwell */
>        { USB_DEVICE(0x5a57, 0x0283), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x5a57, 0x5257), USB_DEVICE_DATA(&rt2800usb_ops) },
> --
> 1.6.6.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
