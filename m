Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49274 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753089AbeDJOjT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 10:39:19 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wcn36xx: Add missing fall through comment in smd.c
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1522929109-23271-1-git-send-email-loic.poulain@linaro.org>
References: <1522929109-23271-1-git-send-email-loic.poulain@linaro.org>
To: Loic Poulain <loic.poulain@linaro.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        dan.carpenter@oracle.com, Loic Poulain <loic.poulain@linaro.org>
Message-Id: <20180410143918.C57CC60AE0@smtp.codeaurora.org> (sfid-20180410_163923_981641_650A6861)
Date: Tue, 10 Apr 2018 14:39:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Loic Poulain <loic.poulain@linaro.org> wrote:

> This prevents GCC warning.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

1391cce7daf6 wcn36xx: Add missing fall through comment in smd.c

-- 
https://patchwork.kernel.org/patch/10324469/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
