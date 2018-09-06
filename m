Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59746 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730278AbeIFUhB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 16:37:01 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] wil6210: fix unsigned cid comparison with >= 0
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180829175018.GA3776@embeddedor.com>
References: <20180829175018.GA3776@embeddedor.com>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Maya Erez <merez@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-Id: <20180906160050.C81F76044E@smtp.codeaurora.org> (sfid-20180906_180102_373234_017315CF)
Date: Thu,  6 Sep 2018 16:00:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> The comparison of cid >= 0 is always true because cid is of type u8
> (8 bits, unsigned).
> 
> Fix this by removing such comparison and updating the type of
> variable cid to u8 in the caller function.
> 
> Addresses-Coverity-ID: 1473079 ("Unsigned compared against 0")
> Fixes: b9010f105f21 ("wil6210: add FT roam support for AP and station")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

49925f247016 wil6210: fix unsigned cid comparison with >= 0

-- 
https://patchwork.kernel.org/patch/10580739/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
