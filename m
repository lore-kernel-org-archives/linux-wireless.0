Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:50572 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750859AbeEUUlf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 16:41:35 -0400
Received: by mail-it0-f65.google.com with SMTP id p3-v6so22639711itc.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 May 2018 13:41:35 -0700 (PDT)
MIME-Version: 1.0
References: <20180521162845.5793-1-guylovesbritt@gmail.com>
In-Reply-To: <20180521162845.5793-1-guylovesbritt@gmail.com>
From: Steve deRosier <derosier@gmail.com>
Date: Mon, 21 May 2018 13:40:58 -0700
Message-ID: <CALLGbRJqDLzj9V07nJxEw4VDBeLKaKGADpPTET2j_4iTyVx53Q@mail.gmail.com> (sfid-20180521_224139_194625_C83CF7B2)
Subject: Re: [PATCH] Added Dell Wireless 1537 Ath6kl sdio card (0x19) to the list.
To: guylovesbritt@gmail.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        guychronister@outlook.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Guy,

On Mon, May 21, 2018 at 9:28 AM Guy Chronister <guylovesbritt@gmail.com>
wrote:

> Signed-off-by: Guy Chronister <guylovesbritt@gmail.com>
> ---
>   drivers/net/wireless/ath/ath6kl/sdio.c | 1 +
>   1 file changed, 1 insertion(+)

> diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c
b/drivers/net/wireless/ath/ath6kl/sdio.c
> index 2195b1b7a8a6..bb50680580f3 100644
> --- a/drivers/net/wireless/ath/ath6kl/sdio.c
> +++ b/drivers/net/wireless/ath/ath6kl/sdio.c
> @@ -1415,6 +1415,7 @@ static const struct sdio_device_id
ath6kl_sdio_devices[] = {
>          {SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE |
0x1))},
>          {SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE |
0x2))},
>          {SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE |
0x18))},
> +       {SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE |
0x19))},
>          {},
>   };


Thanks for this. I'd like to see more information in the git commit
message. While I get that this is some Dell card, it would be helpful to
know what is the actual chip, which firmware, sdio id, and what tests were
done to confirm this worked. Honestly I'm a bit surprised to see a new
ath6k chip ID.

Thanks,
- Steve
