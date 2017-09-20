Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58862 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751971AbdITErE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 00:47:04 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [for-4.14,
 1/2] brcmfmac: add length check in brcmf_cfg80211_escan_handler()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1505206074-28781-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1505206074-28781-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kevin Cernekee <cernekee@chromium.org>
Message-Id: <20170920044704.1633360722@smtp.codeaurora.org> (sfid-20170920_064728_577395_F1FDC303)
Date: Wed, 20 Sep 2017 04:47:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> Upon handling the firmware notification for scans the length was
> checked properly and may result in corrupting kernel heap memory
> due to buffer overruns. This fix addresses CVE-2017-0786.
> 
> Cc: stable@vger.kernel.org # v4.0.x
> Cc: Kevin Cernekee <cernekee@chromium.org>
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

2 patches applied to wireless-drivers.git, thanks.

17df6453d4be brcmfmac: add length check in brcmf_cfg80211_escan_handler()
35f62727df0e brcmfmac: setup passive scan if requested by user-space

-- 
https://patchwork.kernel.org/patch/9948689/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
