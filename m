Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37930 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727597AbeG3TfS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 15:35:18 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] ath10k: htt_tx: move lock into id_get function
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1531589900-29220-1-git-send-email-hofrat@osadl.org>
References: <1531589900-29220-1-git-send-email-hofrat@osadl.org>
To: Nicholas Mc Guire <hofrat@osadl.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <hofrat@osadl.org>
Message-Id: <20180730175909.AE84D60769@smtp.codeaurora.org> (sfid-20180730_200003_082285_C2DC987D)
Date: Mon, 30 Jul 2018 17:59:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nicholas Mc Guire <hofrat@osadl.org> wrote:

> This is only code refactoring as all call sites of
> ath10k_htt_tx_alloc_msdu_id() take the same lock it can be moved into the
> id_get function and the assertion dropped.
> 
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

e82f57c8b970 ath10k: htt_tx: move lock into id_get function

-- 
https://patchwork.kernel.org/patch/10524837/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
