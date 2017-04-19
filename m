Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34519 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764012AbdDSOJ5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Apr 2017 10:09:57 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath: Fix updating radar flags for coutry code India
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1492019377-5556-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1492019377-5556-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <be61b7a7dfe14b338d7c8fef2f3d1ef4@euamsexm01a.eu.qualcomm.com> (sfid-20170419_161000_111384_3F406871)
Date: Wed, 19 Apr 2017 16:09:49 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> As per latest regulatory update for India, channel 52, 56, 60, 64
> is no longer restricted to DFS. Enabling DFS/no infra flags in driver
> results in applying all DFS related restrictions (like doing CAC etc
> before this channel moves to 'available state') for these channels
> even though the country code is programmed as 'India' in he hardware,
> fix this by relaxing the frequency range while applying RADAR flags
> only if the country code is programmed to India. If the frequency range
> needs to modified based on different country code, ath_is_radar_freq
> can be extended/modified dynamically.
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

c0c345d4cacc ath: Fix updating radar flags for coutry code India

-- 
https://patchwork.kernel.org/patch/9678079/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
