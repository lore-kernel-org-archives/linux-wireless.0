Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34273 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbbCTLGg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 07:06:36 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH v2 02/11] ath9k: Register private AIC ops
References: <1426312677-2064-1-git-send-email-sujith@msujith.org>
	<1426312677-2064-3-git-send-email-sujith@msujith.org>
Date: Fri, 20 Mar 2015 13:06:29 +0200
In-Reply-To: <1426312677-2064-3-git-send-email-sujith@msujith.org> (Sujith
	Manoharan's message of "Sat, 14 Mar 2015 11:27:48 +0530")
Message-ID: <87zj78gc7e.fsf@kamboji.qca.qualcomm.com> (sfid-20150320_120642_811336_255F4839)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> AIC can be disabled or enabled on a per-card
> basis using MCI configuration, so register a function
> to check its status.
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

I guess you already saw the error from kbuild:

>> ERROR: "ar9003_hw_attach_aic_ops" [drivers/net/wireless/ath/ath9k/ath9k_hw.ko] undefined!

Can you send a fix for this, please?

-- 
Kalle Valo
