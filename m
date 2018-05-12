Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52990 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750786AbeELJXM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 May 2018 05:23:12 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath10k: remove variables which set but not used
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180507093948.GA7905@blackstone>
References: <20180507093948.GA7905@blackstone>
To: Kenneth Lu <kuohsianglu@gmail.com>
Cc: kvalo@qca.qualcomm.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Message-Id: <20180512092311.D23EA6019F@smtp.codeaurora.org> (sfid-20180512_112316_277951_ABC21486)
Date: Sat, 12 May 2018 09:23:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kenneth Lu <kuohsianglu@gmail.com> wrote:

> Variable buf_len and num_vdev_stats are being assigned but never read.
> These are redundant and can be remove.
> 
> Signed-off-by: Kenneth Lu <kuohsianglu@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

3e2740cda224 ath10k: remove variables which set but not used

-- 
https://patchwork.kernel.org/patch/10383773/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
