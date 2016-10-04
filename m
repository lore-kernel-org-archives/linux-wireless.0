Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33524 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752293AbcJDO7P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 10:59:15 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: add cc_wraparound type for QCA9888 and QCA9884
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1474026327-7065-1-git-send-email-akolli@qti.qualcomm.com>
References: <1474026327-7065-1-git-send-email-akolli@qti.qualcomm.com>
To: <akolli@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>,
        <akolli@codeaurora.org>, <linux-wireless@vger.kernel.org>
Message-ID: <6ec942c23a6144d9a15af4fa8f1238fd@euamsexm01a.eu.qualcomm.com> (sfid-20161004_165917_934822_90D8F67A)
Date: Tue, 4 Oct 2016 16:58:43 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

akolli@qti.qualcomm.com wrote:
> From: Anilkumar Kolli <akolli@qti.qualcomm.com>
> 
> During offchannel scan, iw survey dump shows wrong values.
> Fix this by assigning cycle counter wranarround type for
> QCA9888 and QCA9884, they share same config with QCA4019.
> 
> Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

bafe492610d5 ath10k: add cc_wraparound type for QCA9888 and QCA9884

-- 
https://patchwork.kernel.org/patch/9335581/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
