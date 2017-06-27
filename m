Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52336 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752423AbdF0OQ2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Jun 2017 10:16:28 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] brcmfmac: Fix a memory leak in error handling path in
 'brcmf_cfg80211_attach'
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170621054553.16546-1-christophe.jaillet@wanadoo.fr>
References: <20170621054553.16546-1-christophe.jaillet@wanadoo.fr>
To: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, rafal@milecki.pl,
        pieter-paul.giesberts@broadcom.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        stable@vger.kernel.org
Message-Id: <20170627141616.F24176071A@smtp.codeaurora.org> (sfid-20170627_162114_673468_25FF2691)
Date: Tue, 27 Jun 2017 14:16:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christophe Jaillet <christophe.jaillet@wanadoo.fr> wrote:

> If 'wiphy_new()' fails, we leak 'ops'. Add a new label in the error
> handling path to free it in such a case.
> 
> Cc: stable@vger.kernel.org
> Fixes: 5c22fb85102a7 ("brcmfmac: add wowl gtk rekeying offload support")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Patch applied to wireless-drivers-next.git, thanks.

57c00f2fac51 brcmfmac: Fix a memory leak in error handling path in 'brcmf_cfg80211_attach'

-- 
https://patchwork.kernel.org/patch/9800763/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
