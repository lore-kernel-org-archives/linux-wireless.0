Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42628 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755919AbeDXGFL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 02:05:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/4] ath10k: Add hw params for shadow register support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1523966821-21903-2-git-send-email-pillair@codeaurora.org>
References: <1523966821-21903-2-git-send-email-pillair@codeaurora.org>
To: Rakesh Pillai <pillair@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Message-Id: <20180424060511.392376085F@smtp.codeaurora.org> (sfid-20180424_080514_921159_5E38BD23)
Date: Tue, 24 Apr 2018 06:05:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rakesh Pillai <pillair@codeaurora.org> wrote:

> wcn3990 supports shadow register for ce write.
> 
> Add a hw param for shadow register support.
> 
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

4 patches applied to ath-next branch of ath.git, thanks.

b2e40d7ab8e2 ath10k: add hw params for shadow register support
b7ba83f7c414 ath10k: add support for shadow register for WNC3990
4945af5b264f ath10k: enable SRRI/DRRI support on ddr for WCN3990
d5cded16fdc0 ath10k: enable sta idle power save

-- 
https://patchwork.kernel.org/patch/10344857/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
