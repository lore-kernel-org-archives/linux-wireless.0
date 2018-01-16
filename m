Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53738 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751243AbeAPObw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 09:31:52 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: add sanity check to ie_len before parsing fw/board ie
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1515455461-19286-1-git-send-email-ryanhsu@codeaurora.org>
References: <1515455461-19286-1-git-send-email-ryanhsu@codeaurora.org>
To: ryanhsu@codeaurora.org
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        ryanhsu@codeaurora.org
Message-Id: <20180116143152.40DCD6083C@smtp.codeaurora.org> (sfid-20180116_153156_498791_4830EEDC)
Date: Tue, 16 Jan 2018 14:31:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ryanhsu@codeaurora.org wrote:

> Validate ie_len after the alignment padding before access the buffer
> to avoid potential overflow.
> 
> Signed-off-by: Ryan Hsu <ryanhsu@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

9ed4f9162873 ath10k: add sanity check to ie_len before parsing fw/board ie

-- 
https://patchwork.kernel.org/patch/10150769/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
