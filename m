Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63637 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751538AbdF1Q5P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 12:57:15 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: remove useless variable assignment in ath_mci_intr()
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170626232658.GA17483@embeddedgus>
References: <20170626232658.GA17483@embeddedgus>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
CC: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Message-ID: <36c24b8f739a44adbad3a2b5487cc184@euamsexm01a.eu.qualcomm.com> (sfid-20170628_185752_410465_0014CB54)
Date: Wed, 28 Jun 2017 18:57:07 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gustavo A. R. Silva" <garsilva@embeddedor.com> wrote:

> Value assigned to variable offset at line 551 is overwritten at line 562,
> before it can be used. This makes such variable assignment useless.
> 
> Addresses-Coverity-ID: 1226941
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

6788a3832c70 ath9k: remove useless variable assignment in ath_mci_intr()

-- 
https://patchwork.kernel.org/patch/9810609/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
