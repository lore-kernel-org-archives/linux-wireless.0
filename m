Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59586 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751443AbeGBOak (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jul 2018 10:30:40 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wcn36xx: drop unnecessary initialization of variables
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180629123745.29557-1-daniel@zonque.org>
References: <20180629123745.29557-1-daniel@zonque.org>
To: Daniel Mack <daniel@zonque.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        rfried@codeaurora.org, bjorn.andersson@linaro.org,
        nicolas.dechesne@linaro.org, loic.poulain@linaro.org,
        Daniel Mack <daniel@zonque.org>
Message-Id: <20180702143040.1F37D60B10@smtp.codeaurora.org> (sfid-20180702_163044_264906_0B570593)
Date: Mon,  2 Jul 2018 14:30:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Mack <daniel@zonque.org> wrote:

> Initialization is unneccessary when the variable is written before it is
> read. There were some occasions in which the driver would initialize `ret'
> during declaration without need.
> 
> Purely a cosmetic change with no functional impact.
> 
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

f0eea2772a6b wcn36xx: drop unnecessary initialization of variables

-- 
https://patchwork.kernel.org/patch/10496515/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
