Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54908 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbeH1Rc5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 13:32:57 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] ath10k: Skip resetting rx filter for WCN3990
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1533566888-22221-1-git-send-email-pillair@codeaurora.org>
References: <1533566888-22221-1-git-send-email-pillair@codeaurora.org>
To: Rakesh Pillai <pillair@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Message-Id: <20180828134114.136B060388@smtp.codeaurora.org> (sfid-20180828_154117_620959_22BB6C9F)
Date: Tue, 28 Aug 2018 13:41:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rakesh Pillai <pillair@codeaurora.org> wrote:

> WCN3990 has the MAC_PCU_ADDR1 configured properly
> and hence it will not send spurious ack frames
> during boot up.
> 
> Hence the reset_rx_filter workaround is not needed
> for WCN3990. Add a hw_param to indicate if hardware rx
> filter reset is needed and skip the reset_rx_filter for
> WCN3990.
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1
> 
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

58da3b423070 ath10k: skip resetting rx filter for WCN3990

-- 
https://patchwork.kernel.org/patch/10557325/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
