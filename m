Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:63644 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbaAXTzZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 14:55:25 -0500
Received: by mail-ea0-f176.google.com with SMTP id h14so1191154eaj.35
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 11:55:24 -0800 (PST)
References: <1390290558-6265-1-git-send-email-dubtsov@gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1390290558-6265-1-git-send-email-dubtsov@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <41D642C5-188B-458B-8854-6951D971D775@gmail.com> (sfid-20140124_205529_212414_629EDB80)
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Roman Dubtsov <dubtsov@gmail.com>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: rt2800usb: mark D-Link DWA-137 as supported
Date: Fri, 24 Jan 2014 20:55:23 +0100
To: "dubtsov@gmail.com" <dubtsov@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Sent from my iPad

> On 21 jan. 2014, at 08:49, dubtsov@gmail.com wrote:
> 
> From: Roman Dubtsov <dubtsov@gmail.com>
> 
> Signed-off-by: Roman Dubtsov <dubtsov@gmail.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> drivers/net/wireless/rt2x00/rt2800usb.c | 1 +
> 1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index a81ceb6..ea619c2 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -992,6 +992,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>    { USB_DEVICE(0x07d1, 0x3c15) },
>    { USB_DEVICE(0x07d1, 0x3c16) },
>    { USB_DEVICE(0x07d1, 0x3c17) },
> +    { USB_DEVICE(0x2001, 0x3317) },
>    { USB_DEVICE(0x2001, 0x3c1b) },
>    /* Draytek */
>    { USB_DEVICE(0x07fa, 0x7712) },
> -- 
> 1.8.5.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
