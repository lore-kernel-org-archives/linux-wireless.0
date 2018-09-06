Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33652 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbeIFUjo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 16:39:44 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCHv2 1/4] ath10k: get the legacy rate index to update the
 txrate table
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1536043516-12462-2-git-send-email-akolli@codeaurora.org>
References: <1536043516-12462-2-git-send-email-akolli@codeaurora.org>
To: akolli@codeaurora.org
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@codeaurora.org>
Message-Id: <20180906160333.81A51606FA@smtp.codeaurora.org> (sfid-20180906_180342_067623_8F57F4B0)
Date: Thu,  6 Sep 2018 16:03:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

akolli@codeaurora.org wrote:

> Get the legacy rate index to update the pkts/bytes counter
> against each possible tx rate.
> 
> Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

4 patches applied to ath-next branch of ath.git, thanks.

0189dbd71cbd ath10k: get the legacy rate index to update the txrate table
348cd95c8196 ath10k: add debugfs entry to enable extended tx stats
a904417fc876 ath10k: add extended per sta tx statistics support
85dd28eb9917 ath10k: add debugfs support to dump per sta tx stats

-- 
https://patchwork.kernel.org/patch/10586755/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
