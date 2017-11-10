Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51244 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750802AbdKJGNj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Nov 2017 01:13:39 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v6] brcmfmac: add CLM download support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1507188678-24985-1-git-send-email-wright.feng@cypress.com>
References: <1507188678-24985-1-git-send-email-wright.feng@cypress.com>
To: Wright Feng <wright.feng@cypress.com>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>
Message-Id: <20171110061338.A5785607EA@smtp.codeaurora.org> (sfid-20171110_071342_858555_34ACD66C)
Date: Fri, 10 Nov 2017 06:13:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wright Feng <wright.feng@cypress.com> wrote:

> From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> 
> The firmware for brcmfmac devices includes information regarding
> regulatory constraints. For certain devices this information is kept
> separately in a binary form that needs to be downloaded to the device.
> This patch adds support to download this so-called CLM blob file. It
> uses the same naming scheme as the other firmware files with extension
> of .clm_blob.
> 
> The CLM blob file is optional. If the file does not exist, the download
> process will be bypassed. It will not affect the driver loading.
> 
> Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Didn't apply:

error: Failed to merge in the changes.
Applying: brcmfmac: add CLM download support
Using index info to reconstruct a base tree...
M	drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
M	drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
M	drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
M	drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
M	drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
M	drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
M	drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
CONFLICT (content): Merge conflict in drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
Patch failed at 0001 brcmfmac: add CLM download support
The copy of the patch that failed is found in: .git/rebase-apply/patch

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9986493/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
