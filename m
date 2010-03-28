Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:59441 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754985Ab0C1SsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Mar 2010 14:48:03 -0400
Message-ID: <4BAFA45B.5080503@gmail.com>
Date: Sun, 28 Mar 2010 20:47:55 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	IvDoorn@gmail.com
Subject: Re: [PATCH 4/4] wireless: rt2x00: rt2800usb: new ids
References: <1269799361-12257-1-git-send-email-xose.vazquez@gmail.com>
In-Reply-To: <1269799361-12257-1-git-send-email-xose.vazquez@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/28/10 20:02, Xose Vazquez Perez wrote:
> Taken from latest ralink linux driver(RT3070_LinuxSTA_V2.3.0.1_20100208)
> All of them are RT3070 devices.
> 
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index c1cc15d..03a85f7 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -910,6 +910,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
>  	/* AzureWave */
>  	{ USB_DEVICE(0x13d3, 0x3273), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	{ USB_DEVICE(0x13d3, 0x3305), USB_DEVICE_DATA(&rt2800usb_ops) },
> +	{ USB_DEVICE(0x13d3, 0x3307), USB_DEVICE_DATA(&rt2800usb_ops) },
> +	{ USB_DEVICE(0x13d3, 0x3321), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	/* Conceptronic */
>  	{ USB_DEVICE(0x14b2, 0x3c12), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	/* Corega */
> @@ -920,6 +922,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
>  	{ USB_DEVICE(0x07d1, 0x3c0e), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	{ USB_DEVICE(0x07d1, 0x3c0f), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	{ USB_DEVICE(0x07d1, 0x3c16), USB_DEVICE_DATA(&rt2800usb_ops) },
> +	/* Draytek */
> +	{ USB_DEVICE(0x07fa, 0x7712), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	/* Edimax */
>  	{ USB_DEVICE(0x7392, 0x7711), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	/* Encore */
> @@ -938,6 +942,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
>  	{ USB_DEVICE(0x04bb, 0x0945), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	{ USB_DEVICE(0x04bb, 0x0947), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	{ USB_DEVICE(0x04bb, 0x0948), USB_DEVICE_DATA(&rt2800usb_ops) },
> +	/* Logitec */
> +	{ USB_DEVICE(0x0789, 0x0166), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	/* MSI */
>  	{ USB_DEVICE(0x0db0, 0x3820), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	{ USB_DEVICE(0x0db0, 0x3821), USB_DEVICE_DATA(&rt2800usb_ops) },
> @@ -946,8 +952,12 @@ static struct usb_device_id rt2800usb_device_table[] = {
>  	{ USB_DEVICE(0x0db0, 0x3871), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	{ USB_DEVICE(0x0db0, 0x821a), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	{ USB_DEVICE(0x0db0, 0x822a), USB_DEVICE_DATA(&rt2800usb_ops) },
> +	{ USB_DEVICE(0x0db0, 0x822b), USB_DEVICE_DATA(&rt2800usb_ops) },
> +	{ USB_DEVICE(0x0db0, 0x822c), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	{ USB_DEVICE(0x0db0, 0x870a), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	{ USB_DEVICE(0x0db0, 0x871a), USB_DEVICE_DATA(&rt2800usb_ops) },
> +	{ USB_DEVICE(0x0db0, 0x871b), USB_DEVICE_DATA(&rt2800usb_ops) },
> +	{ USB_DEVICE(0x0db0, 0x871c), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	{ USB_DEVICE(0x0db0, 0x899a), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	/* Para */
>  	{ USB_DEVICE(0x20b8, 0x8888), USB_DEVICE_DATA(&rt2800usb_ops) },
> @@ -972,6 +982,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>  	{ USB_DEVICE(0x083a, 0x7511), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	{ USB_DEVICE(0x083a, 0xa701), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	{ USB_DEVICE(0x083a, 0xa702), USB_DEVICE_DATA(&rt2800usb_ops) },
> +	{ USB_DEVICE(0x083a, 0xa703), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	/* Zinwell */
>  	{ USB_DEVICE(0x5a57, 0x0283), USB_DEVICE_DATA(&rt2800usb_ops) },
>  	{ USB_DEVICE(0x5a57, 0x5257), USB_DEVICE_DATA(&rt2800usb_ops) },

