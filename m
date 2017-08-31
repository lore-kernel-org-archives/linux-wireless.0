Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57110 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750828AbdHaNAV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 09:00:21 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl8723be: fix duplicated code for different branches
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170830170424.GA19424@embeddedgus>
References: <20170830170424.GA19424@embeddedgus>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-Id: <20170831130020.259C56182F@smtp.codeaurora.org> (sfid-20170831_150044_939503_9D66720F)
Date: Thu, 31 Aug 2017 13:00:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> Refactor code in order to avoid identical code for different branches.
> 
> Addresses-Coverity-ID: 1248728
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers-next.git, thanks.

a9a65a6b2b69 rtlwifi: rtl8723be: fix duplicated code for different branches

-- 
https://patchwork.kernel.org/patch/9930325/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
