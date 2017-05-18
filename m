Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52866 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932575AbdERNg4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 09:36:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V3,
 5/9] brcmfmac: add firmware feature detection for gscan feature
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1492776308-15120-6-git-send-email-arend.vanspriel@broadcom.com>
References: <1492776308-15120-6-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20170518133655.91D0660F60@smtp.codeaurora.org> (sfid-20170518_153801_608726_E8B9BB7C)
Date: Thu, 18 May 2017 13:36:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> From: Arend van Spriel <arend@broadcom.com>
> 
> Detect gscan support in firmware by doing pfn_gscan_cfg iovar with
> invalid version.
> 
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Failed to apply:

fatal: sha1 information is lacking or useless (drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c).
error: could not build fake ancestor
Applying: brcmfmac: add support multi-scheduled scan
Patch failed at 0001 brcmfmac: add support multi-scheduled scan
The copy of the patch that failed is found in: .git/rebase-apply/patch

5 patches set to Changes Requested.

9692541 [V3,5/9] brcmfmac: add firmware feature detection for gscan feature
9692537 [V3,6/9] brcmfmac: move scheduled scan wiphy param setting to pno module
9692543 [V3,7/9] brcmfmac: add support multi-scheduled scan
9692535 [V3,8/9] brcmfmac: add mutex to protect pno requests
9692539 [V3,9/9] brcmfmac: add scheduled scan support for specified BSSIDs

-- 
https://patchwork.kernel.org/patch/9692541/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
