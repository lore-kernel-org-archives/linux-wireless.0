Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59240 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab1HDHzW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Aug 2011 03:55:22 -0400
Received: by wwe5 with SMTP id 5so1624165wwe.1
        for <linux-wireless@vger.kernel.org>; Thu, 04 Aug 2011 00:55:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1312444052-31691-1-git-send-email-hacker@epn.ru>
References: <1312444052-31691-1-git-send-email-hacker@epn.ru>
Date: Thu, 4 Aug 2011 13:25:21 +0530
Message-ID: <CAD2nsn2jDG-7ipaAar5QwiT2E_LN1EdAttJTdBKio_jXqy=83w@mail.gmail.com> (sfid-20110804_095525_779024_4FD4C665)
Subject: Re: [PATCH v2] ath9k: fix a misprint which leads to incorrect calibration
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Alex Hacker <hacker@epn.ru>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 4, 2011 at 1:17 PM, Alex Hacker <hacker@epn.ru> wrote:
> This patch addresses an issue with incorrect HW register
> AR_PHY_TX_IQCAL_CORR_COEFF_B1 definition which leads to incorrect clibration.
>
> Cc: stable@kernel.org
> Signed-off-by: Alex Hacker <hacker@epn.ru>

thanks Alex!

> ---
>  drivers/net/wireless/ath/ath9k/ar9003_phy.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
> index 6de3f0b..5c59042 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
> @@ -850,7 +850,7 @@
>  #define AR_PHY_TPC_11_B1         (AR_SM1_BASE + 0x220)
>  #define AR_PHY_PDADC_TAB_1       (AR_SM1_BASE + 0x240)
>  #define AR_PHY_TX_IQCAL_STATUS_B1   (AR_SM1_BASE + 0x48c)
> -#define AR_PHY_TX_IQCAL_CORR_COEFF_B1(_i)    (AR_SM_BASE + 0x450 + ((_i) << 2))
> +#define AR_PHY_TX_IQCAL_CORR_COEFF_B1(_i)    (AR_SM1_BASE + 0x450 + ((_i) << 2))
>
>  /*
>  * Channel 2 Register Map
> --
> 1.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
shafi
