Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43614 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753120AbeDJOaE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 10:30:04 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [next] wil6210: fix potential null dereference of ndev before
 null check
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180328174027.31551-1-colin.king@canonical.com>
References: <20180328174027.31551-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20180410143003.A40E460AFB@smtp.codeaurora.org> (sfid-20180410_163030_881570_C1FD3BC3)
Date: Tue, 10 Apr 2018 14:30:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> The pointer ndev is being dereferenced before it is being null checked,
> hence there is a potential null pointer deference. Fix this by only
> dereferencing ndev after it has been null checked
> 
> Detected by CoverityScan, CID#1467010 ("Dereference before null check")
> 
> Fixes: e00243fab84b ("wil6210: infrastructure for multiple virtual interfaces")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Reviewed-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

db5a4d5e1073 wil6210: fix potential null dereference of ndev before null check

-- 
https://patchwork.kernel.org/patch/10313705/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
