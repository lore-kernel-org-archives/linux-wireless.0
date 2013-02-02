Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:62361 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933Ab3BBOrL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2013 09:47:11 -0500
Received: by mail-wg0-f47.google.com with SMTP id dr13so3694527wgb.14
        for <linux-wireless@vger.kernel.org>; Sat, 02 Feb 2013 06:47:10 -0800 (PST)
References: <1359772424-17250-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1359772424-17250-1-git-send-email-xose.vazquez@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <004BF0DB-9847-46EC-AA05-E43426D3B354@gmail.com> (sfid-20130202_154715_893536_9352F8E3)
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] wireless: rt2x00: rt2800usb add Sweex ids
Date: Sat, 2 Feb 2013 15:39:16 +0100
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Sent from my iPad

On 2 feb. 2013, at 03:33, Xose Vazquez Perez <xose.vazquez@gmail.com> wrote:

> Info coming from Sweex Windows driver and wikidevi.com
> 0x177f,0x0163 Sweex LW163 RT3370 1x1, int. antenna
> 0x177f,0x0164 Sweex LW164 RT8070 1x1, Nano dongle
> 0x177f,0x0165 Sweex LW165 RT3370 1x1, ext. antenna
> 0x177f,0x0324 Sweex LW324 RT3072 2x2  with 32Mb NOR flash, autoinstall
> 
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Gertjan van Wingerde <gwingerde@gmail.com>
> Cc: Helmut Schaa <helmut.schaa@googlemail.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: users@rt2x00.serialmonkey.com
> Cc: linux-wireless@vger.kernel.org
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> drivers/net/wireless/rt2x00/rt2800usb.c | 5 +++++
> 1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 42b5b65..8a57646 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -1099,9 +1099,11 @@ static struct usb_device_id rt2800usb_device_table[] = {
>    { USB_DEVICE(0x15a9, 0x0006) },
>    /* Sweex */
>    { USB_DEVICE(0x177f, 0x0153) },
> +    { USB_DEVICE(0x177f, 0x0164) },
>    { USB_DEVICE(0x177f, 0x0302) },
>    { USB_DEVICE(0x177f, 0x0313) },
>    { USB_DEVICE(0x177f, 0x0323) },
> +    { USB_DEVICE(0x177f, 0x0324) },
>    /* U-Media */
>    { USB_DEVICE(0x157e, 0x300e) },
>    { USB_DEVICE(0x157e, 0x3013) },
> @@ -1133,6 +1135,9 @@ static struct usb_device_id rt2800usb_device_table[] = {
>    { USB_DEVICE(0x148f, 0x8070) },
>    /* Sitecom */
>    { USB_DEVICE(0x0df6, 0x0050) },
> +    /* Sweex */
> +    { USB_DEVICE(0x177f, 0x0163) },
> +    { USB_DEVICE(0x177f, 0x0165) },
> #endif
> #ifdef CONFIG_RT2800USB_RT35XX
>    /* Allwin */
> -- 
> 1.7.11.7
> 
