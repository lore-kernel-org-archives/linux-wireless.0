Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50416 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbeDYIYB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 04:24:01 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmsmac: phy_lcn: remove duplicate code
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180405000944.GA22743@embeddedor.com>
References: <20180405000944.GA22743@embeddedor.com>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-Id: <20180425082401.5442F607C6@smtp.codeaurora.org> (sfid-20180425_102422_946894_B83BC298)
Date: Wed, 25 Apr 2018 08:24:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> Remove and refactor some code in order to avoid having identical code
> for different branches.
> 
> Notice that this piece of code hasn't been modified since 2011.
> 
> Addresses-Coverity-ID: 1226756 ("Identical code for different branches")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Patch applied to wireless-drivers-next.git, thanks.

863683cfbbfc brcmsmac: phy_lcn: remove duplicate code

-- 
https://patchwork.kernel.org/patch/10323665/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
