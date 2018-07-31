Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59328 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729592AbeGaJBd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 05:01:33 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH V2] brcmfmac: specify some features per firmware version
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180709045543.15031-1-zajec5@gmail.com>
References: <20180709045543.15031-1-zajec5@gmail.com>
To: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Message-Id: <20180731072238.3120E606AC@smtp.codeaurora.org> (sfid-20180731_092320_801868_0F6A8063)
Date: Tue, 31 Jul 2018 07:22:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Some features supported by firmware aren't advertised and there is no
> way for a driver to query them. This includes e.g. monitor mode details.
> 
> Most firmwares support monitor interface but only the latest ones
> /announce/ it with a "monitor" flag in the "cap" iovar. There isn't any
> reliable detection method for older firmwares (BRCMF_C_MONITOR was tried
> but "it only indicates the core part of the stack supports").
> 
> Similarly support for tagging monitor frames and building radiotap
> headers can't be reliably detected for all firmwares.
> 
> This commit adds table that allows mapping features to firmware version.
> It adds mappings for 43602a1 and 4366b1 firmwares from
> linux-firmware.git. Both were confirmed to be passing monitor frames.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

1e591c56a65f brcmfmac: specify some features per firmware version

-- 
https://patchwork.kernel.org/patch/10513497/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
