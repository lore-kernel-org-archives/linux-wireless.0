Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42860 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727494AbeHJOdM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Aug 2018 10:33:12 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: VIJAYAKUMAAR K T <vijay.bvb@samsung.com>
Cc: "davem\@davemloft.net" <davem@davemloft.net>,
        "ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        CPGS <cpgs@samsung.com>
Subject: Re: [PATCH 1/1] ath10k: avoid possible memory access violation
References: <1533292805-9709-1-git-send-email-vijay.bvb@samsung.com>
        <CGME20180803104058epcas1p1d5cdd51e2774d72679aaf15358cb3d00@epcms5p1>
        <20180810101916epcms5p1e3d60d9cbc49f9a7c9529d87d691f359@epcms5p1>
Date: Fri, 10 Aug 2018 15:03:28 +0300
In-Reply-To: <20180810101916epcms5p1e3d60d9cbc49f9a7c9529d87d691f359@epcms5p1>
        (VIJAYAKUMAAR K. T.'s message of "Fri, 10 Aug 2018 15:49:16 +0530")
Message-ID: <87eff6zawf.fsf@kamboji.qca.qualcomm.com> (sfid-20180810_140352_412582_41F2479E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

VIJAYAKUMAAR K T <vijay.bvb@samsung.com> writes:

> It would be great, if this patch could be reviewed.

It's in the queue and you can check the state from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#checking_state_of_patches_from_patchwork

-- 
Kalle Valo
