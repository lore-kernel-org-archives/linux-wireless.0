Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39426 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751756AbeB0Qnn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 11:43:43 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Fix log message for hif power on failure
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1517803894-4250-1-git-send-email-govinds@codeaurora.org>
References: <1517803894-4250-1-git-send-email-govinds@codeaurora.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Message-Id: <20180227164342.AF79760285@smtp.codeaurora.org> (sfid-20180227_174401_684085_F9317F8E)
Date: Tue, 27 Feb 2018 16:43:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Govind Singh <govinds@codeaurora.org> wrote:

> HIF power-on failure is applicable to each underlying
> bus type. Fix log message for hif power on failure.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

cf0d37aecc06 ath10k: fix log message for hif power on failure

-- 
https://patchwork.kernel.org/patch/10199829/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
