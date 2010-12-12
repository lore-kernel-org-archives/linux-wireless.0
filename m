Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41371 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab0LLR3v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Dec 2010 12:29:51 -0500
Received: by qwa26 with SMTP id 26so5442153qwa.19
        for <linux-wireless@vger.kernel.org>; Sun, 12 Dec 2010 09:29:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19716.42722.13272.204029@gargle.gargle.HOWL>
References: <19716.42722.13272.204029@gargle.gargle.HOWL>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 12 Dec 2010 18:29:29 +0100
Message-ID: <AANLkTimMAv9e5M+=DG8RVyHjNVc68dHJepUdOuLjr+Dd@mail.gmail.com>
Subject: Re: [PATCH] ath9k_htc: Add Ubiquity wifistation ext to supported devices
To: Sujith <m.sujith@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Sujith.Manoharan@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 12, 2010 at 11:41 AM, Sujith <m.sujith@gmail.com> wrote:
> From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
>
> Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/hif_usb.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index 45d4b24..f09c1d8 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -38,6 +38,7 @@ static struct usb_device_id ath9k_hif_usb_ids[] = {
>        { USB_DEVICE(0x13D3, 0x3350) }, /* Azurewave */
>        { USB_DEVICE(0x04CA, 0x4605) }, /* Liteon */
>        { USB_DEVICE(0x040D, 0x3801) }, /* VIA */
> +       { USB_DEVICE(0x0cf3, 0xb003) }, /* Ubiquity WifiStation Ext */

Typo: it's spelled Ubiquiti.

>
>        { USB_DEVICE(0x0cf3, 0x7015),
>          .driver_info = AR9287_USB },  /* Atheros */
> --
> 1.7.3.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
