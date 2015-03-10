Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:32777 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbbCJInk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 04:43:40 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21758.44950.886418.51899@gargle.gargle.HOWL> (sfid-20150310_094346_316485_3B89F2F2)
Date: Tue, 10 Mar 2015 14:17:18 +0530
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH 0/7] ath9k patches
In-Reply-To: <1425976534-1194-1-git-send-email-sujith@msujith.org>
References: <1425976534-1194-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

Sorry, I forgot to mention that this is intended for -next.

Sujith

Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> This series adds initial support for AIC.
> 
> Active Interference Cancellation is a method
> implemented in the HW to counter WLAN RX
> sensitivity degradation when BT is transmitting
> at the same time. This feature is supported by
> cards like WB222 based on AR9462.
> 
> Sujith Manoharan (7):
>   ath9k: Add initial structures for AIC
>   ath9k: Register private AIC ops
>   ath9k: Add register definitions for AIC
>   ath9k: Handle MCI_STATE_AIC_CAL_SINGLE
>   ath9k: Finish AIC calibration
>   ath9k: Process the AIC calibration results
>   ath9k: Disable AIC by default
> 
>  drivers/net/wireless/ath/ath9k/Makefile     |   3 +-
>  drivers/net/wireless/ath/ath9k/ar9003_aic.c | 534 ++++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath9k/ar9003_aic.h |  58 +++
>  drivers/net/wireless/ath/ath9k/ar9003_hw.c  |   1 +
>  drivers/net/wireless/ath/ath9k/ar9003_mci.c |   5 +
>  drivers/net/wireless/ath/ath9k/ar9003_phy.h |  25 --
>  drivers/net/wireless/ath/ath9k/btcoex.h     |  12 +
>  drivers/net/wireless/ath/ath9k/hw-ops.h     |   8 +
>  drivers/net/wireless/ath/ath9k/hw.h         |   6 +
>  drivers/net/wireless/ath/ath9k/reg_aic.h    | 168 +++++++++
>  10 files changed, 794 insertions(+), 26 deletions(-)
>  create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_aic.c
>  create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_aic.h
>  create mode 100644 drivers/net/wireless/ath/ath9k/reg_aic.h
> 
> -- 
> 2.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
