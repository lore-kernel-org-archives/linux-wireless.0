Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40938 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965627AbeEYJrz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 05:47:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: add fw crash dump support for QCA9888 and QCA99X0
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1525781496-14776-1-git-send-email-akolli@codeaurora.org>
References: <1525781496-14776-1-git-send-email-akolli@codeaurora.org>
To: Anilkumar Kolli <akolli@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Message-Id: <20180525094755.460F860A06@smtp.codeaurora.org> (sfid-20180525_114947_791498_0CC8FFB1)
Date: Fri, 25 May 2018 09:47:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anilkumar Kolli <akolli@codeaurora.org> wrote:

> This patch adds firmware crash memory dump support for QCA9888 and QCA99X0.
> 
> Tested on:
> 
> QCA9888 firmware 10.4-3.5.3-00053
> QCA99X0 firmware 10.4.1.00030-1
> 
> Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

46dbf98c69f4 ath10k: add memory dump support for QCA9888 and QCA99X0

-- 
https://patchwork.kernel.org/patch/10386041/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
