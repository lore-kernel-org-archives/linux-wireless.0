Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:36138 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965238AbbBCNfW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 08:35:22 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/17] ath9k patches
References: <1422624937-4810-1-git-send-email-sujith@msujith.org>
Date: Tue, 03 Feb 2015 15:35:16 +0200
In-Reply-To: <1422624937-4810-1-git-send-email-sujith@msujith.org> (Sujith
	Manoharan's message of "Fri, 30 Jan 2015 19:05:20 +0530")
Message-ID: <87mw4vw223.fsf@kamboji.qca.qualcomm.com> (sfid-20150203_143525_539745_0541BD3C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> ath9k patches for -next.
>
> Sujith Manoharan (17):
>   ath9k: Remove ATH9K_HW_WOW_DEVICE_CAPABLE
>   ath9k: Return early for error conditions
>   ath9k: Remove redundant device_can_wakeup() check
>   ath9k: Check early for multi-vif/STA conditions
>   ath9k: Check multi-channel context for WOW
>   ath9k: Fix wow init/deinit
>   ath9k: Check WOW triggers properly
>   ath9k: Remove unused BMISS processing
>   ath9k: Remove ath9k_hw_wow_event_to_string
>   ath9k: Add a debugfs file for WOW
>   ath9k: Simplify user pattern configuration
>   ath9k: Add a HW structure for WOW
>   ath9k: Register max WOW patterns
>   ath9k: Move WOW registers to reg_wow.h
>   ath9k: Remove incorrect register macros
>   ath9k: Cleanup reg_wow.h
>   ath9k: Fix max pattern check

Thanks, all 17 applied to wireless-drivers-next.git.

-- 
Kalle Valo
