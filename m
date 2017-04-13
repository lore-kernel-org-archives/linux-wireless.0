Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16843 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751139AbdDMMpK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 08:45:10 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Fix compile time sanity check for CE4 buffer size
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1491324776-8418-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1491324776-8418-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Michal Kazior <michal.kazior@tieto.com>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <fb36131b433b45d282e6d7c09d309380@euamsexm01a.eu.qualcomm.com> (sfid-20170413_144514_543192_DE197BCE)
Date: Thu, 13 Apr 2017 14:45:02 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> In 'ath10k_ce_alloc_pipe' the compile time sanity check to
> ensure that there is sufficient buffers in CE4 for HTT Tx
> MSDU descriptors, but this did not take into account of the
> case with 'peer flow control' enabled, fix this.
> 
> Cc: Michal Kazior <michal.kazior@tieto.com>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

62ca0690cd49 ath10k: fix compile time sanity check for CE4 buffer size

-- 
https://patchwork.kernel.org/patch/9662059/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
