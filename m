Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34524 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753576AbeDSP7L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 11:59:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: correct target assert problem due to CE5 stuck
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1523535410-29333-1-git-send-email-mpubbise@codeaurora.org>
References: <1523535410-29333-1-git-send-email-mpubbise@codeaurora.org>
To: mpubbise@codeaurora.org
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Message-Id: <20180419155910.A073E6022B@smtp.codeaurora.org> (sfid-20180419_175914_780403_E353DA4C)
Date: Thu, 19 Apr 2018 15:59:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mpubbise@codeaurora.org wrote:

> Correct a minor bug in the commit 0628467f97b5 ("ath10k: fix
> copy engine 5 destination ring stuck") which introduced a change to fix
> firmware assert that happens when ring indices of copy engine 5 are stuck
> for a specific duration, problem with this fix is that it did not use
> ring arithmatic. As a result,firmware asserts did not go away entirely
> athough the frequency of occurrence has reduced. Using ring arithmatic
> to fix the issue.
> 
> Tested on QCA9984(fw version-10.4-3.4-00082).
> 
> Fixes: 0628467f97b5 ("ath10k: fix copy engine 5 destination ring stuck)
> Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

1e8f77502341 ath10k: correct target assert problem due to CE5 stuck

-- 
https://patchwork.kernel.org/patch/10338443/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
