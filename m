Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57444 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727406AbeH1RgC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 13:36:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] net: wireless: ath9k: Remove unnecessary parentheses
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180725185305.4118-1-rvarsha016@gmail.com>
References: <20180725185305.4118-1-rvarsha016@gmail.com>
To: Varsha Rao <rvarsha016@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Nicholas Mc Guire <der.herr@hofr.at>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Varsha Rao <rvarsha016@gmail.com>
Message-Id: <20180828134418.B3556602AE@smtp.codeaurora.org> (sfid-20180828_154429_973644_55FCF348)
Date: Tue, 28 Aug 2018 13:44:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Varsha Rao <rvarsha016@gmail.com> wrote:

> Remove extra parentheses to fix the clang warning of extraneous
> parentheses.
> 
> Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

bf05e0fe7da4 ath9k: Remove unnecessary parentheses

-- 
https://patchwork.kernel.org/patch/10544571/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
