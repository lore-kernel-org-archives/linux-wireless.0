Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45788 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbbCMNbQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 09:31:16 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/5] ath9k patches
References: <1425891010-21522-1-git-send-email-sujith@msujith.org>
Date: Fri, 13 Mar 2015 15:31:10 +0200
In-Reply-To: <1425891010-21522-1-git-send-email-sujith@msujith.org> (Sujith
	Manoharan's message of "Mon, 9 Mar 2015 14:20:05 +0530")
Message-ID: <87wq2lqb1d.fsf@kamboji.qca.qualcomm.com> (sfid-20150313_143119_786861_1480D5C1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> For -next.
>
> Sujith Manoharan (5):
>   ath9k: Add PCIE powersave macros
>   ath9k: Fix PLL powersave for AR9485
>   ath9k: Initialize pll_pwrsave for AR9462/AR9565
>   ath9k: Check allowed PCIE powersave configuration
>   ath9k: Fix RTT chainmask usage

With these patches I got a new warning:

drivers/net/wireless/ath/ath9k/ar9003_aic.c: In function 'ar9003_aic_cal_post_process':
drivers/net/wireless/ath/ath9k/ar9003_aic.c:431:1: warning: the frame size of 1312 bytes is larger than 1024 bytes [-Wframe-larger-than=]

Is it a valid warning?

-- 
Kalle Valo
