Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:63543 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130AbaJaJrl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2014 05:47:41 -0400
Message-ID: <54535ABA.1030109@suse.cz> (sfid-20141031_104745_976805_E749A58E)
Date: Fri, 31 Oct 2014 10:47:38 +0100
From: Jiri Slaby <jslaby@suse.cz>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: stable@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH -stable] wireless: rt2x00: add new rt2800usb devices
References: <1414667923-2331-1-git-send-email-xose.vazquez@gmail.com>
In-Reply-To: <1414667923-2331-1-git-send-email-xose.vazquez@gmail.com>
Content-Type: text/plain; charset=iso-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/30/2014, 12:18 PM, Xose Vazquez Perez wrote:
> 0x0b05 0x17e8 RT5372 USB 2.0  bgn 2x2 ASUS USB-N14
> 0x0411 0x0253 RT5572 USB 2.0 abgn 2x2 BUFFALO WLP-U2-300D
> 0x0df6 0x0078 RT???? Sitecom N300

(the same as previous)

> Cc: stable@vger.kernel.org
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Cc: Stanislaw Gruszka <sgruszka@redhat.com>
> Cc: Helmut Schaa <helmut.schaa@googlemail.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: users@rt2x00.serialmonkey.com
> Cc: linux-wireless@vger.kernel.org
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 832006b..573897b 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -1284,6 +1284,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
>  	/* Arcadyan */
>  	{ USB_DEVICE(0x043e, 0x7a12) },
>  	{ USB_DEVICE(0x043e, 0x7a32) },
> +	/* ASUS */
> +	{ USB_DEVICE(0x0b05, 0x17e8) },
>  	/* Azurewave */
>  	{ USB_DEVICE(0x13d3, 0x3329) },
>  	{ USB_DEVICE(0x13d3, 0x3365) },
> @@ -1320,6 +1322,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>  	{ USB_DEVICE(0x057c, 0x8501) },
>  	/* Buffalo */
>  	{ USB_DEVICE(0x0411, 0x0241) },
> +	{ USB_DEVICE(0x0411, 0x0253) },
>  	/* D-Link */
>  	{ USB_DEVICE(0x2001, 0x3c1a) },
>  	{ USB_DEVICE(0x2001, 0x3c21) },
> @@ -1410,6 +1413,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>  	{ USB_DEVICE(0x0df6, 0x0053) },
>  	{ USB_DEVICE(0x0df6, 0x0069) },
>  	{ USB_DEVICE(0x0df6, 0x006f) },
> +	{ USB_DEVICE(0x0df6, 0x0078) },
>  	/* SMC */
>  	{ USB_DEVICE(0x083a, 0xa512) },
>  	{ USB_DEVICE(0x083a, 0xc522) },
> 


-- 
js
suse labs
