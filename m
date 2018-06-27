Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45442 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965049AbeF0P6C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 11:58:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmsmac: make function wlc_phy_workarounds_nphy_rev1 static
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180623221531.6396-2-colin.king@canonical.com>
References: <20180623221531.6396-2-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20180627155802.26F41601EA@smtp.codeaurora.org> (sfid-20180627_175820_998300_24D2D154)
Date: Wed, 27 Jun 2018 15:58:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The function wlc_phy_workarounds_nphy_rev1 is local to the source and
> does not need to be in global scope, so make it static.
> 
> Cleans up sparse warning:
> symbol 'wlc_phy_workarounds_nphy_rev1' was not declared. Should it
> be static?
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

ab8d904654e2 brcmsmac: make function wlc_phy_workarounds_nphy_rev1 static

-- 
https://patchwork.kernel.org/patch/10483927/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
