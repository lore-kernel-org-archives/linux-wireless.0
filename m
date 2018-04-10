Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44318 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753047AbeDJObK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 10:31:10 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: sdio: fix memory leak for probe allocations
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180327203144.8998-1-marcus.folkesson@gmail.com>
References: <20180327203144.8998-1-marcus.folkesson@gmail.com>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>
Message-Id: <20180410143110.6F94B60AFB@smtp.codeaurora.org> (sfid-20180410_163136_522878_D7CF8DAD)
Date: Tue, 10 Apr 2018 14:31:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcus Folkesson <marcus.folkesson@gmail.com> wrote:

> These allocations are not freed upon release.
> When on it; go for managed resources instead.
> 
> Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
> [kvalo: fix two checkpatch warnings]
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

ec2c64e20257 ath10k: sdio: fix memory leak for probe allocations

-- 
https://patchwork.kernel.org/patch/10311597/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
