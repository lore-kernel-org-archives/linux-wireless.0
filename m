Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45364 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751981AbcKOPGJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 10:06:09 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3,1/2] ath10k: clean up HTT tx buffer allocation and free
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1476278778-4253-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1476278778-4253-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <b46170abfbc548458e6be817f9d31079@euamsexm01a.eu.qualcomm.com> (sfid-20161115_160612_881361_FF14E2EA)
Date: Tue, 15 Nov 2016 16:06:02 +0100
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

2 patches applied to ath-next branch of ath.git, thanks.

19f338c6eb0c ath10k: clean up HTT tx buffer allocation and free
f004e532a80a ath10k: remove extraneous error message in tx alloc

-- 
https://patchwork.kernel.org/patch/9373055/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
