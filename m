Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57304 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751725AbeAPOfg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 09:35:36 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix recently introduced checkpatch warnings
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <151610005703.17030.17977783056615638055.stgit@potku.adurom.net>
References: <151610005703.17030.17977783056615638055.stgit@potku.adurom.net>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Message-Id: <20180116143535.E01B360A00@smtp.codeaurora.org> (sfid-20180116_153540_913500_4A6B1E5E)
Date: Tue, 16 Jan 2018 14:35:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> wrote:

> Checkpatch found these issues:
> 
> drivers/net/wireless/ath/ath10k/ce.h:324: Please use a blank line after function/struct/union/enum declarations
> drivers/net/wireless/ath/ath10k/core.c:1321: Please don't use multiple blank lines
> drivers/net/wireless/ath/ath10k/htt.h:1859: Please use a blank line after function/struct/union/enum declarations
> 
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

a3e712b74b5f ath10k: fix recently introduced checkpatch warnings

-- 
https://patchwork.kernel.org/patch/10166449/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
