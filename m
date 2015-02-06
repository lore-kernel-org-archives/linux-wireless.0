Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:38168 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbbBFGlQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 01:41:16 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/6] ath9k patches
References: <1422881473-24580-1-git-send-email-sujith@msujith.org>
Date: Fri, 06 Feb 2015 08:41:10 +0200
In-Reply-To: <1422881473-24580-1-git-send-email-sujith@msujith.org> (Sujith
	Manoharan's message of "Mon, 2 Feb 2015 18:21:07 +0530")
Message-ID: <87r3u3pmnt.fsf@kamboji.qca.qualcomm.com> (sfid-20150206_074119_525311_C3493316)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> ath9k patches for -next.
>
> Sujith Manoharan (6):
>   ath9k: Add support for more WOW patterns
>   ath9k: Register correct WOW details with mac80211
>   ath9k: Fix issues with WoW enable
>   ath9k: Program AR_WA correctly
>   ath9k: Clear TSF2 properly
>   ath9k: Choose correct rate for 2GHz channel

Thanks, all six patches applied.

-- 
Kalle Valo
