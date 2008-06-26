Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp6.pp.htv.fi ([213.243.153.40]:51329 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbYFZQOD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 12:14:03 -0400
Date: Thu, 26 Jun 2008 19:11:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ben Collins <ben.collins@canonical.com>
Cc: Linus Torvalds <torvalds@osdl.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	flamingice@sourmilk.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Comment out duplicate device entry
Message-ID: <20080626161152.GE22025@cs181140183.pp.htv.fi> (sfid-20080626_181407_929978_473F5AC4)
References: <1214495838.7150.10.camel@cunning>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1214495838.7150.10.camel@cunning>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 26, 2008 at 11:57:18AM -0400, Ben Collins wrote:
> Left it commented instead of removing since it referenced a different
> model name. Just avoid it getting back in by mistake, and to document
> that it is supported.

No, it's the same the same model name (MD stands for Medion).

But it shouldn't be listed as both version 1 and version 2 device.

I've added the driver maintainer to the Cc.

> Signed-off-by: Ben Collins <ben.collins@canonical.com>
> 
> diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
> index 1610a73..f0369d0 100644
> --- a/drivers/net/wireless/p54/p54usb.c
> +++ b/drivers/net/wireless/p54/p54usb.c
> @@ -60,7 +60,7 @@ static struct usb_device_id p54u_table[] __devinitdata = {
>  	{USB_DEVICE(0x0915, 0x2002)},	/* Cohiba Proto board */
>  	{USB_DEVICE(0x0baf, 0x0118)},   /* U.S. Robotics U5 802.11g Adapter*/
>  	{USB_DEVICE(0x0bf8, 0x1009)},   /* FUJITSU E-5400 USB D1700*/
> -	{USB_DEVICE(0x0cde, 0x0006)},   /* Medion MD40900 */
> +// DUPE	{USB_DEVICE(0x0cde, 0x0006)},   /* Medion MD40900 */
>  	{USB_DEVICE(0x0cde, 0x0008)},	/* Sagem XG703A */
>  	{USB_DEVICE(0x0d8e, 0x3762)},	/* DLink DWL-G120 Cohiba */
>  	{USB_DEVICE(0x09aa, 0x1000)},	/* Spinnaker Proto board */

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

