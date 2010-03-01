Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f212.google.com ([209.85.218.212]:46351 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab0CARYu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 12:24:50 -0500
Received: by bwz4 with SMTP id 4so1912579bwz.28
        for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 09:24:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1003011205211.28884@eidolons.org>
References: <51a465a61002281248jc7701abq642b67f0b68ed80a@mail.gmail.com>
	 <4B8B3A1A.80403@gmail.com>
	 <alpine.LNX.2.00.1003011205211.28884@eidolons.org>
Date: Mon, 1 Mar 2010 18:24:46 +0100
Message-ID: <a32f33a41003010924q43616ffhb858feac7b9ebb4a@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: Add USB ID for CEIVA adapter to rt73usb
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Bryan Polk <sainth@eidolons.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 1, 2010 at 6:23 PM, Bryan Polk <sainth@eidolons.org> wrote:
> This adds support for CEIVA USB wireless adapters to the rt73usb driver.
>
> Signed-off-by: Bryan Polk <sainth@eidolons.org>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
> index f39a8ed..47f3e4a 100644
> --- a/drivers/net/wireless/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/rt2x00/rt73usb.c
> @@ -2352,6 +2352,8 @@ static struct usb_device_id rt73usb_device_table[] = {
>        { USB_DEVICE(0x0411, 0x00f4), USB_DEVICE_DATA(&rt73usb_ops) },
>        { USB_DEVICE(0x0411, 0x0116), USB_DEVICE_DATA(&rt73usb_ops) },
>        { USB_DEVICE(0x0411, 0x0119), USB_DEVICE_DATA(&rt73usb_ops) },
> +       /* CEIVA */
> +       { USB_DEVICE(0x178d, 0x02be), USB_DEVICE_DATA(&rt73usb_ops) },
>        /* CNet */
>        { USB_DEVICE(0x1371, 0x9022), USB_DEVICE_DATA(&rt73usb_ops) },
>        { USB_DEVICE(0x1371, 0x9032), USB_DEVICE_DATA(&rt73usb_ops) },
>
