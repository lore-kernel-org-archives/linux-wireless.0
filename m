Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50372 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751345AbeAPO3p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 09:29:45 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath9k: add MSI support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171011101806.6295-1-rhu@qti.qualcomm.com>
References: <20171011101806.6295-1-rhu@qti.qualcomm.com>
To: Russell Hu <rhu@qti.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <rhu@qti.qualcomm.com>,
        <ryanhsu@qti.qualcomm.com>, <rwchang@qti.qualcomm.com>,
        <aeolus@qti.qualcomm.com>, <kvalo@qca.qualcomm.com>
Message-Id: <20180116142945.61B43602BA@smtp.codeaurora.org> (sfid-20180116_152950_563630_898611B8)
Date: Tue, 16 Jan 2018 14:29:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Russell Hu <rhu@qti.qualcomm.com> wrote:

> On new Intel platforms like ApolloLake, legacy interrupt mechanism
> (INTx) is not supported, so WLAN modules are not working because
> interrupts are missing, therefore this patch is to add MSI support to
> ath9k.  With module paremeter "use_msi=1", ath9k driver would try to
> use MSI instead of INTx.
> 
> Signed-off-by: Russell Hu <rhu@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

7368160f0ab0 ath9k: add MSI support

-- 
https://patchwork.kernel.org/patch/9999249/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
