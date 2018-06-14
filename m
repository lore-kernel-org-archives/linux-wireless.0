Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45620 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755058AbeFNPJD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 11:09:03 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Support use of channel 173
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1514940661-13590-1-git-send-email-greearb@candelatech.com>
References: <1514940661-13590-1-git-send-email-greearb@candelatech.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Ben Greear <greearb@candelatech.com>
Message-Id: <20180614150902.B75A76055D@smtp.codeaurora.org> (sfid-20180614_170907_789669_6D96B748)
Date: Thu, 14 Jun 2018 15:09:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> wrote:

> The India regulatory domain allows CH 173, so add that to the
> available channel list.  I verified basic connectivity between
> a 9880 and 9984 NIC.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

38441fb6fcbb ath10k: support use of channel 173

-- 
https://patchwork.kernel.org/patch/10141515/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
