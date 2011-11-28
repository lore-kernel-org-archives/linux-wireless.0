Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38063 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab1K1Cws convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Nov 2011 21:52:48 -0500
Received: by iage36 with SMTP id e36so8207723iag.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Nov 2011 18:52:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322439734-14520-2-git-send-email-mar.kolya@gmail.com>
References: <1322439734-14520-1-git-send-email-mar.kolya@gmail.com> <1322439734-14520-2-git-send-email-mar.kolya@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 28 Nov 2011 13:52:28 +1100
Message-ID: <CAGRGNgVouJ_XneiR0nXe04Tc6bxPpgvT7sdCXaxg1eUhX5y+tg@mail.gmail.com> (sfid-20111128_035252_118930_E4775F97)
Subject: Re: [PATCH v2 1/4] ath9k: trivial: cosmetic fix in calibration debug log
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nikolay,

Minor nit:

On Mon, Nov 28, 2011 at 11:22, Nikolay Martynov <mar.kolya@gmail.com> wrote:
>  Add missed space and change typo in calibration debugging log.
>
> Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9002_calib.c |    2 +-
>  drivers/net/wireless/ath/ath9k/ar9003_calib.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> index 12a730d..4b3c70a 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> @@ -225,7 +225,7 @@ static void ar9003_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
>                        i);
>
>                ath_dbg(common, ATH_DBG_CALIBRATE,
> -                       "Orignal: Chn %diq_corr_meas = 0x%08x\n",
> +                       "Original: Chn %diq_corr_meas = 0x%08x\n",

You haven't put a space after the %d like you did in the other file.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
