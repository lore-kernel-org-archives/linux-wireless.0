Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:50446 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660Ab0CADw7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2010 22:52:59 -0500
Message-ID: <4B8B3A1A.80403@gmail.com>
Date: Mon, 01 Mar 2010 04:52:58 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Alaan <sainth@eidolons.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>
Subject: Re: [PATCH] rt2x00: add USB ID for CEIVA adapter to rt73usb
References: <51a465a61002281248jc7701abq642b67f0b68ed80a@mail.gmail.com>
In-Reply-To: <51a465a61002281248jc7701abq642b67f0b68ed80a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/28/10 21:48, Alaan wrote:
> First time submitting a patch, apologies if I did something wrong.
> Tested this adapter for a couple days and it seems stable.
> 
> diff --git a/drivers/net/wireless/rt2x00/rt73usb.c
> b/drivers/net/wireless/rt2x00/rt73usb.c
> index f39a8ed..47f3e4a 100644
> --- a/drivers/net/wireless/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/rt2x00/rt73usb.c
> @@ -2352,6 +2352,8 @@ static struct usb_device_id rt73usb_device_table[] = {
>         { USB_DEVICE(0x0411, 0x00f4), USB_DEVICE_DATA(&rt73usb_ops) },
>         { USB_DEVICE(0x0411, 0x0116), USB_DEVICE_DATA(&rt73usb_ops) },
>         { USB_DEVICE(0x0411, 0x0119), USB_DEVICE_DATA(&rt73usb_ops) },
> +       /* CEIVA */
> +       { USB_DEVICE(0x178d, 0x02be), USB_DEVICE_DATA(&rt73usb_ops) },
>         /* CNet */
>         { USB_DEVICE(0x1371, 0x9022), USB_DEVICE_DATA(&rt73usb_ops) },
>         { USB_DEVICE(0x1371, 0x9032), USB_DEVICE_DATA(&rt73usb_ops) },
> 

Hi,

In order for your patch to be considered for inclusion you will have to include
a Signed-off-by line with your own name and email address in the patch description.

See Documentation/SubmittingPatches of a kernel tree for more information on this.

---
Gertjan.
