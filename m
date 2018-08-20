Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44518 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbeHTMgp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Aug 2018 08:36:45 -0400
Received: by mail-wr1-f68.google.com with SMTP id r16-v6so12346375wrt.11
        for <linux-wireless@vger.kernel.org>; Mon, 20 Aug 2018 02:21:53 -0700 (PDT)
Date: Mon, 20 Aug 2018 11:21:50 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76x2u: Add support for Alfa AWUS036ACM
Message-ID: <20180820092149.GA4245@localhost.localdomain> (sfid-20180820_112156_807278_37A88C13)
References: <1534030432-229-1-git-send-email-rosenp@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534030432-229-1-git-send-email-rosenp@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Aug 11, Rosen Penev wrote:
> A 2x2 unit with a USB dock for optimal placement.
> 
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x2_usb.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_usb.c b/drivers/net/wireless/mediatek/mt76/mt76x2_usb.c
> index 1428cfd..f5338c3 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x2_usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x2_usb.c
> @@ -20,6 +20,7 @@
>  #include "mt76x2u.h"
>  
>  static const struct usb_device_id mt76x2u_device_table[] = {
> +	{ USB_DEVICE(0x0e8d, 0x7612) }, /* Alfa AWUS036ACM */
>  	{ USB_DEVICE(0x0b05, 0x1833) },	/* Asus USB-AC54 */
>  	{ USB_DEVICE(0x0b05, 0x17eb) },	/* Asus USB-AC55 */
>  	{ USB_DEVICE(0x0b05, 0x180b) },	/* Asus USB-N53 B1 */
> -- 
> 2.7.4
> 

Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
