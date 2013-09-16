Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:55393 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab3IPGyz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 02:54:55 -0400
Received: by mail-lb0-f178.google.com with SMTP id z5so3948543lbh.9
        for <linux-wireless@vger.kernel.org>; Sun, 15 Sep 2013 23:54:54 -0700 (PDT)
Message-ID: <5236AB38.9000304@gmail.com> (sfid-20130916_085458_917292_A7E9804B)
Date: Mon, 16 Sep 2013 08:54:48 +0200
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
To: Albert Pool <albertpool@solcon.nl>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] ar5523: Add USB ID of D-Link WUA-2340 rev A1
References: <1378751790-2465-1-git-send-email-albertpool@solcon.nl>
In-Reply-To: <1378751790-2465-1-git-send-email-albertpool@solcon.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-09-09 20:36, Albert Pool wrote:
> Signed-off-by: Albert Pool <albertpool@solcon.nl>
> Reported-by: Michael Landrum <landrummd@gmail.com>
> ---
>   drivers/net/wireless/ath/ar5523/ar5523.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
> index 17d7fec..280fc3d 100644
> --- a/drivers/net/wireless/ath/ar5523/ar5523.c
> +++ b/drivers/net/wireless/ath/ar5523/ar5523.c
> @@ -1762,6 +1762,7 @@ static struct usb_device_id ar5523_id_table[] = {
>   	AR5523_DEVICE_UX(0x2001, 0x3a00),	/* Dlink / DWLAG132 */
>   	AR5523_DEVICE_UG(0x2001, 0x3a02),	/* Dlink / DWLG132 */
>   	AR5523_DEVICE_UX(0x2001, 0x3a04),	/* Dlink / DWLAG122 */
> +	AR5523_DEVICE_UG(0x07d1, 0x3a07),	/* D-Link / WUA-2340 rev A1 */
>   	AR5523_DEVICE_UG(0x1690, 0x0712),	/* Gigaset / AR5523 */
>   	AR5523_DEVICE_UG(0x1690, 0x0710),	/* Gigaset / SMCWUSBTG */
>   	AR5523_DEVICE_UG(0x129b, 0x160c),	/* Gigaset / USB stick 108
>


Acked-by: Pontus Fuchs <pontus.fuchs@gmail.com>

Thanks,

Pontus
