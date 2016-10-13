Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64506 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932484AbcJMOXw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 10:23:52 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] ath9k: change entropy formula for easier understanding
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
To: miaoqing pan <miaoqing@codeaurora.org>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
        <linux-crypto@vger.kernel.org>, <smueller@chronox.de>,
        <jason@lakedaemon.net>, <pouyans@qti.qualcomm.com>,
        Miaoqing Pan <miaoqing@codeaurora.org>
Message-ID: <86c1ac2596344035856cf7a504b8868f@euamsexm01a.eu.qualcomm.com> (sfid-20161013_162412_988260_8617E3EF)
Date: Thu, 13 Oct 2016 16:23:43 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

miaoqing pan <miaoqing@codeaurora.org> wrote:
> From: Miaoqing Pan <miaoqing@codeaurora.org>
> 
> The quality of ADC entropy is 10 bits of min-entropy for
> a 32-bit value, change '(((x) * 8 * 320) >> 10)' to
> '(((x) * 8 * 10) >> 5)' for easier understanding.
> 
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

e463139a7262 ath9k: change entropy formula for easier understanding

-- 
https://patchwork.kernel.org/patch/9270463/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
