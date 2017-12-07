Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:30705 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753354AbdLGOld (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 09:41:33 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Fix invalid STS_CAP_OFFSET_MASK.
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1510679819-24115-1-git-send-email-greearb@candelatech.com>
References: <1510679819-24115-1-git-send-email-greearb@candelatech.com>
To: Ben Greear <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        Ben Greear <greearb@candelatech.com>
Message-ID: <b186e066fba046d592be1d29008ffad6@euamsexm01a.eu.qualcomm.com> (sfid-20171207_154137_505898_AE4656A1)
Date: Thu, 7 Dec 2017 15:41:25 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> wrote:

> The 10.4 firmware defines this as a 3-bit field, as does the
> mac80211 stack.  The 4th bit is defined as CONF_IMPLICIT_BF
> at least in the firmware header I have seen.  This patch
> fixes the ath10k wmi header to match the firmware.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

8cec57f5277e ath10k: fix invalid STS_CAP_OFFSET_MASK

-- 
https://patchwork.kernel.org/patch/10057943/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
