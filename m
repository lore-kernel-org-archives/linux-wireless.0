Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51888 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab1HBSCa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 14:02:30 -0400
Date: Tue, 2 Aug 2011 13:50:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Alex Hacker <hacker@epn.ru>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Misprint in ar9003_phy.h. Fix a misprint wich can
 cause incorrect calibration process.
Message-ID: <20110802175024.GG14167@tuxdriver.com> (sfid-20110802_200234_334135_1B22B9BD)
References: <1312297234-24166-1-git-send-email-hacker@epn.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1312297234-24166-1-git-send-email-hacker@epn.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 02, 2011 at 09:00:34PM +0600, Alex Hacker wrote:
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_phy.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Missing Signed-off-by...
 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
> index 6de3f0b..5c59042 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
> @@ -850,7 +850,7 @@
>  #define AR_PHY_TPC_11_B1         (AR_SM1_BASE + 0x220)
>  #define AR_PHY_PDADC_TAB_1       (AR_SM1_BASE + 0x240)
>  #define AR_PHY_TX_IQCAL_STATUS_B1   (AR_SM1_BASE + 0x48c)
> -#define AR_PHY_TX_IQCAL_CORR_COEFF_B1(_i)    (AR_SM_BASE + 0x450 + ((_i) << 2))
> +#define AR_PHY_TX_IQCAL_CORR_COEFF_B1(_i)    (AR_SM1_BASE + 0x450 + ((_i) << 2))
>  
>  /*
>   * Channel 2 Register Map
> -- 
> 1.7.4
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
