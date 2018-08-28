Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:32820 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbeH1Rih (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 13:38:37 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] net: wireless: ath6kl: Remove unnecessary parentheses
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180725184949.4032-1-rvarsha016@gmail.com>
References: <20180725184949.4032-1-rvarsha016@gmail.com>
To: Varsha Rao <rvarsha016@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Nicholas Mc Guire <der.herr@hofr.at>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Varsha Rao <rvarsha016@gmail.com>
Message-Id: <20180828134652.09837604BE@smtp.codeaurora.org> (sfid-20180828_154709_649273_F8062083)
Date: Tue, 28 Aug 2018 13:46:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Varsha Rao <rvarsha016@gmail.com> wrote:

> Remove extra parentheses to fix the clang warning of extraneous
> parentheses.
> 
> Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

4ac1f003e72a ath6kl: Remove unnecessary parentheses

-- 
https://patchwork.kernel.org/patch/10544569/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
