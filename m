Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41678 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934647AbdEVPV5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 May 2017 11:21:57 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: remove setting IBSS mode when stopping AP
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1495099339-7626-1-git-send-email-wright.feng@cypress.com>
References: <1495099339-7626-1-git-send-email-wright.feng@cypress.com>
To: Wright Feng <wright.feng@cypress.com>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, wright.feng@cypress.com,
        Chi-hsien Lin <Chi-Hsien.Lin@cypress.com>
Message-Id: <20170522152156.6446960B75@smtp.codeaurora.org> (sfid-20170522_172234_297866_83FAF461)
Date: Mon, 22 May 2017 15:21:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wright Feng <wright.feng@cypress.com> wrote:
> From: Chi-hsien Lin <Chi-Hsien.Lin@cypress.com>
> 
> Upon stopping an AP interface the driver disable INFRA mode effectively 
> setting the interface in IBSS mode. However, this may affect other 
> interfaces running in INFRA mode. For instance, if user creates and stops
> hostap daemon on virtual interface, then association cannot work on
> primary interface because default BSS has been set to IBSS mode in
> firmware side. The IBSS mode should be set when cfg80211 changes the
> interface.
> 
> Reviewed-by: Wright Feng <wright.feng@cypress.com>
> Signed-off-by: Chi-hsien Lin <Chi-Hsien.Lin@cypress.com>
> [kvalo@codeaurora.org: rephased commit log based on discussion]
> Signed-off-by: Wright Feng <wright.feng@cypress.com>

Patch applied to wireless-drivers-next.git, thanks.

9029679f66d9 brcmfmac: remove setting IBSS mode when stopping AP

-- 
https://patchwork.kernel.org/patch/9733205/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
