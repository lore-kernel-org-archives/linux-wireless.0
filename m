Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48164 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932181AbcJFHho (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Oct 2016 03:37:44 -0400
Date: Thu, 6 Oct 2016 13:07:30 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [1/2] ath10k: clean up HTT tx buffer allocation and free
Message-ID: <20161006073730.GA6601@atheros-ThinkPad-T61> (sfid-20161006_093747_905179_E7D5B645)
References: <1475584772-4091-2-git-send-email-mohammed@qca.qualcomm.com>
 <dc6b3afe60574d7bb60e1913da3f1ad4@euamsexm01a.eu.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <dc6b3afe60574d7bb60e1913da3f1ad4@euamsexm01a.eu.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 06, 2016 at 09:31:41AM +0200, Kalle Valo wrote:
> Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> > From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> > 
> > cleanup 'ath10k_htt_tx_alloc' by introducing the API's
> > 'ath10k_htt_tx_alloc/free_{cont_txbuf, txdone_fifo} and
> > re-use them whereever needed
> > 
> > Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Patch 1 doesn't apply and the conflict was not trivial

[shafi] oops will rebase it, not sure how i missed it :-(

> 
> error: patch failed: drivers/net/wireless/ath/ath10k/htt_tx.c:388
> error: drivers/net/wireless/ath/ath10k/htt_tx.c: patch does not apply
> stg import: Diff does not apply cleanly
> error: patch failed: drivers/net/wireless/ath/ath10k/htt_tx.c:283
> error: drivers/net/wireless/ath/ath10k/htt_tx.c: patch does not apply
> stg import: Diff does not apply cleanly
> 
> 2 patches set to Changes Requested.
> 
> 9361741 [1/2] ath10k: clean up HTT tx buffer allocation and free
> 9361743 [2/2] ath10k: Remove extraneous error message in tx alloc
> 
> -- 
> https://patchwork.kernel.org/patch/9361741/
> 
> Documentation about submitting wireless patches and checking status
> from patchwork:
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
> 
