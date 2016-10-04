Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3968 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751541AbcJDPai (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 11:30:38 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Cleanup calling ath10k_htt_rx_h_unchain
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1474981314-15987-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1474981314-15987-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <2cb38dba80294e6da1005ac0927d01eb@euamsexm01a.eu.qualcomm.com> (sfid-20161004_173042_281938_F2E98C69)
Date: Tue, 4 Oct 2016 17:30:17 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> 'ath10k_htt_rx_h_unchain' is need to be called only if the return
> value from 'ath10k_htt_rx_amsdu_pop' is 1('chained msdu's'), this
> change makes it more explicit and avoids doing a skb_peek, fetching
> rx descriptor pointer, checking rx msdu decap format for the case of
> ret = 0 (unchained msdus). Found this change during code walk through,
> not sure if this addresses any issue.
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Failed to apply to pending branch

error: patch failed: drivers/net/wireless/ath/ath10k/htt_rx.c:1550
error: drivers/net/wireless/ath/ath10k/htt_rx.c: patch does not apply
stg import: Diff does not apply cleanly

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9351833/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
