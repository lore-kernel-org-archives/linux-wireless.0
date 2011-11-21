Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61917 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab1KUEgn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 23:36:43 -0500
Received: by wwe5 with SMTP id 5so9741537wwe.1
        for <linux-wireless@vger.kernel.org>; Sun, 20 Nov 2011 20:36:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321836540-5325-2-git-send-email-mar.kolya@gmail.com>
References: <1321836540-5325-1-git-send-email-mar.kolya@gmail.com>
	<1321836540-5325-2-git-send-email-mar.kolya@gmail.com>
Date: Mon, 21 Nov 2011 10:06:42 +0530
Message-ID: <CAD2nsn0mHLbDYuZMfSumJNavCbrFbK-3XWuLW1U1T+kY7Ecj-w@mail.gmail.com> (sfid-20111121_053647_455856_535390D2)
Subject: Re: [PATCH 1/4] ath9k: cosmetic fix in calibration debug log
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 21, 2011 at 6:18 AM, Nikolay Martynov <mar.kolya@gmail.com> wrote:
> ---
>  drivers/net/wireless/ath/ath9k/ar9002_calib.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
> index 88279e3..6cfc393 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
> @@ -203,7 +203,7 @@ static void ar9002_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
>                        i);
>
>                ath_dbg(common, ATH_DBG_CALIBRATE,
> -                       "Orignal: Chn %diq_corr_meas = 0x%08x\n",
> +                       "Orignal: Chn %d iq_corr_meas = 0x%08x\n",

thanks, please also change Orignal to Original :)
please make the same changes in ar9003_calib.c

>                        i, ah->totalIqCorrMeas[i]);
>
>                iqCorrNeg = 0;
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
shafi
