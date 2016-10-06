Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43928 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752345AbcJFHbt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Oct 2016 03:31:49 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] ath10k: clean up HTT tx buffer allocation and free
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1475584772-4091-2-git-send-email-mohammed@qca.qualcomm.com>
References: <1475584772-4091-2-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <dc6b3afe60574d7bb60e1913da3f1ad4@euamsexm01a.eu.qualcomm.com> (sfid-20161006_093153_150002_BEA6DA1D)
Date: Thu, 6 Oct 2016 09:31:41 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> cleanup 'ath10k_htt_tx_alloc' by introducing the API's
> 'ath10k_htt_tx_alloc/free_{cont_txbuf, txdone_fifo} and
> re-use them whereever needed
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Patch 1 doesn't apply and the conflict was not trivial

error: patch failed: drivers/net/wireless/ath/ath10k/htt_tx.c:388
error: drivers/net/wireless/ath/ath10k/htt_tx.c: patch does not apply
stg import: Diff does not apply cleanly
error: patch failed: drivers/net/wireless/ath/ath10k/htt_tx.c:283
error: drivers/net/wireless/ath/ath10k/htt_tx.c: patch does not apply
stg import: Diff does not apply cleanly

2 patches set to Changes Requested.

9361741 [1/2] ath10k: clean up HTT tx buffer allocation and free
9361743 [2/2] ath10k: Remove extraneous error message in tx alloc

-- 
https://patchwork.kernel.org/patch/9361741/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
