Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54448 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751003AbcI1JoY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 05:44:24 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [-next] ath10k: fix error return code in ahb
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1474031135-6963-1-git-send-email-weiyj.lk@gmail.com>
References: <1474031135-6963-1-git-send-email-weiyj.lk@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: Raja Mani <rmani@qti.qualcomm.com>,
        <linux-wireless@vger.kernel.org>,
        "Wei Yongjun" <weiyongjun1@huawei.com>,
        <ath10k@lists.infradead.org>
Message-ID: <65bd7c68b413408cbb37dd2ff152d423@euamsexm01a.eu.qualcomm.com> (sfid-20160928_114443_053979_7D68017F)
Date: Wed, 28 Sep 2016 11:44:16 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Fix to return a negative error code from the error handling case
> instead of 0, as done elsewhere in function ath10k_ahb_probe() or
> ath10k_ahb_resource_init().
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Patch applied to ath-next branch of ath.git, thanks.

931eb6b7fee3 ath10k: fix error return code in ahb

-- 
https://patchwork.kernel.org/patch/9335759/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
