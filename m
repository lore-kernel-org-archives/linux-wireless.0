Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11128 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753317AbdCIICy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Mar 2017 03:02:54 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wcn36xx: Fix error handling
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170219174751.18966-1-christophe.jaillet@wanadoo.fr>
References: <20170219174751.18966-1-christophe.jaillet@wanadoo.fr>
To: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
CC: <k.eugene.e@gmail.com>, <kvalo@codeaurora.org>,
        <wcn36xx@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <b37f84dce99d4f6fa577845f664aaba6@euamsexm01a.eu.qualcomm.com> (sfid-20170309_090433_049445_4D5E7560)
Date: Thu, 9 Mar 2017 09:02:44 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christophe Jaillet <christophe.jaillet@wanadoo.fr> wrote:
> Reorder 'out_free_dxe_pool' and 'out_free_dxe_ctl' error handling labels
> in order to match the way resources have been allocated.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Patch applied to ath-next branch of ath.git, thanks.

4aa2d31f5df8 wcn36xx: Fix error handling

-- 
https://patchwork.kernel.org/patch/9581709/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
