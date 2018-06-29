Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55754 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754720AbeF2L76 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 07:59:58 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/3] wcn36xx: Fix WEP104 encryption type
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1529481480-13247-1-git-send-email-loic.poulain@linaro.org>
References: <1529481480-13247-1-git-send-email-loic.poulain@linaro.org>
To: Loic Poulain <loic.poulain@linaro.org>
Cc: wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>
Message-Id: <20180629115958.5FD5760791@smtp.codeaurora.org> (sfid-20180629_140002_393722_5B508EBC)
Date: Fri, 29 Jun 2018 11:59:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Loic Poulain <loic.poulain@linaro.org> wrote:

> This is an obvious copy & paste bug.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

3 patches applied to ath-next branch of ath.git, thanks.

10db60b9fab7 wcn36xx: Fix WEP104 encryption type
e3160542ab48 wcn36xx: Track associated stations
216da1287a8a wcn36xx: Fix WEP encryption

-- 
https://patchwork.kernel.org/patch/10476621/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
