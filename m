Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48894 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754244AbdA0SIS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 13:08:18 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] ath10k: remove multiple defines of DIAG_TRANSFER_LIMIT
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1485183876-27080-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1485183876-27080-1-git-send-email-srinivas.kandagatla@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
CC: <netdev@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ath10k@lists.infradead.org>
Message-ID: <10e75338551b4824b607cd630521b2f0@eusanexr01a.eu.qualcomm.com> (sfid-20170127_191143_493129_099FC8C0)
Date: Fri, 27 Jan 2017 10:04:54 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Srinivas Kandagatla <srinivas.kandagatla@linaro.org> wrote:
> DIAG_TRANSFER_LIMIT is redefined with same value and comments
> just below this entry, remove this duplicate entry.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

3 patches applied to ath-next branch of ath.git, thanks.

dd51fa3d8a1d ath10k: remove multiple defines of DIAG_TRANSFER_LIMIT
0de4df5ba2ad ath10k: use dma_zalloc_coherent()
1ad38fd719da ath10k: fix typo in addr calculation

-- 
https://patchwork.kernel.org/patch/9532691/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
