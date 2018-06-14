Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51508 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754927AbeFNPVn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 11:21:43 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Handle resource init failure case
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180613064806.32286-1-govinds@codeaurora.org>
References: <20180613064806.32286-1-govinds@codeaurora.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Message-Id: <20180614152143.070CF606DB@smtp.codeaurora.org> (sfid-20180614_172147_403780_FADABECB)
Date: Thu, 14 Jun 2018 15:21:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Govind Singh <govinds@codeaurora.org> wrote:

> Return type of resource init method is not assigned.
> Handle resource init failures for graceful exit.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

d16a7ab20ac9 ath10k: handle resource init failure case

-- 
https://patchwork.kernel.org/patch/10461677/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
