Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41838 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751062AbeB0Qo7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 11:44:59 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: update the IRAM banks number for QCA9377
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1518135631-29796-1-git-send-email-ryanhsu@codeaurora.org>
References: <1518135631-29796-1-git-send-email-ryanhsu@codeaurora.org>
To: ryanhsu@codeaurora.org
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        ryanhsu@codeaurora.org
Message-Id: <20180227164459.2E3C460285@smtp.codeaurora.org> (sfid-20180227_174503_525529_D82C20FD)
Date: Tue, 27 Feb 2018 16:44:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ryanhsu@codeaurora.org wrote:

> Preparation for a new QCA9377 firmware release. The new firmware release
> requires more IRAM banks, hence update that on ath10k.
> 
> The IRAM banks promotion won't break any backwards compatibility, as those IRAM
> banks were not getting used in previous firmware releases.
> 
> Signed-off-by: Ryan Hsu <ryanhsu@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

fc8b92635f79 ath10k: update the IRAM bank number for QCA9377

-- 
https://patchwork.kernel.org/patch/10208159/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
