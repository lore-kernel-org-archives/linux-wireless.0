Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51572 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751888AbcI1KAn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 06:00:43 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/2] ath9k: disable RNG by default
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1470726147-30095-2-git-send-email-miaoqing@codeaurora.org>
References: <1470726147-30095-2-git-send-email-miaoqing@codeaurora.org>
To: miaoqing pan <miaoqing@codeaurora.org>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
        <linux-crypto@vger.kernel.org>, <smueller@chronox.de>,
        <jason@lakedaemon.net>, <pouyans@qti.qualcomm.com>,
        Miaoqing Pan <miaoqing@codeaurora.org>
Message-ID: <079a0f54e6da4cd39f1247d059a73a5d@euamsexm01a.eu.qualcomm.com> (sfid-20160928_120047_916937_3748F3CF)
Date: Wed, 28 Sep 2016 12:00:35 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

miaoqing pan <miaoqing@codeaurora.org> wrote:
> From: Miaoqing Pan <miaoqing@codeaurora.org>
> 
> ath9k RNG will dominates all the noise sources from the real HW
> RNG, disable it by default. But we strongly recommand to enable
> it if the system without HW RNG, especially on embedded systems.
> 
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
> Acked-by: Stephan Mueller <smueller@chronox.de>
> Acked-by: Stephan Mueller <smueller@chronox.de>
> Reviewed-by: Jason Cooper <jason@lakedaemon.net>

Patch applied to ath-next branch of ath.git, thanks.

739ccd76b40e ath9k: disable RNG by default

-- 
https://patchwork.kernel.org/patch/9270467/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
