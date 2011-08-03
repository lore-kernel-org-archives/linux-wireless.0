Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37168 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab1HCJUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2011 05:20:19 -0400
Received: by wyg8 with SMTP id 8so397477wyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Aug 2011 02:20:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1312345838-26609-1-git-send-email-hacker@epn.ru>
References: <1312345838-26609-1-git-send-email-hacker@epn.ru>
Date: Wed, 3 Aug 2011 14:50:17 +0530
Message-ID: <CAD2nsn1KHx3tqewEz38wr_YO_10UvjT8=k5v9uZonsMcCx4g4w@mail.gmail.com> (sfid-20110803_112023_023917_25D90E22)
Subject: Re: [PATCH] ath9k: fix a misprint which can lead to incorrect calibration
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Alex Hacker <hacker@epn.ru>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 3, 2011 at 10:00 AM, Alex Hacker <hacker@epn.ru> wrote:
>
> Signed-off-by: Alex Hacker <hacker@epn.ru>
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

Hi Alex,

please send this patch cc'ing stable@kernel.org, as this will fix
AR9003 chip sets calibration

-- 
shafi
