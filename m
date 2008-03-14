Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:45889 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbYCNSyU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2008 14:54:20 -0400
Received: by fk-out-0910.google.com with SMTP id 19so259058fkr.5
        for <linux-wireless@vger.kernel.org>; Fri, 14 Mar 2008 11:54:16 -0700 (PDT)
To: Masakazu Mokuno <mokuno@sm.sony.co.jp>
Subject: Re: [PATCH] rt2x00: Add id for Corega CG-WLUSB2GPX
Date: Fri, 14 Mar 2008 19:53:45 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <20080314190922.2594.40F06B3A@sm.sony.co.jp>
In-Reply-To: <20080314190922.2594.40F06B3A@sm.sony.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803141953.46191.IvDoorn@gmail.com> (sfid-20080314_185427_491849_5F24DA19)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> This adds the id for Corega CG-WLUSB2GPX.

Applied to rt2x00.git.

Thanks.

Ivo

> Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
> ---
>  Tested with wpa_supplicant (wext wrapper) on PS3 with the F8 userland.
> 
>  drivers/net/wireless/rt2x00/rt73usb.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- a/drivers/net/wireless/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/rt2x00/rt73usb.c
> @@ -2095,6 +2095,8 @@ static struct usb_device_id rt73usb_devi
>  	{ USB_DEVICE(0x1371, 0x9032), USB_DEVICE_DATA(&rt73usb_ops) },
>  	/* Conceptronic */
>  	{ USB_DEVICE(0x14b2, 0x3c22), USB_DEVICE_DATA(&rt73usb_ops) },
> +	/* Corega */
> +	{ USB_DEVICE(0x07aa, 0x002e), USB_DEVICE_DATA(&rt73usb_ops) },
>  	/* D-Link */
>  	{ USB_DEVICE(0x07d1, 0x3c03), USB_DEVICE_DATA(&rt73usb_ops) },
>  	{ USB_DEVICE(0x07d1, 0x3c04), USB_DEVICE_DATA(&rt73usb_ops) },
> 


