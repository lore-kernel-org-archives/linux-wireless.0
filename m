Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34498 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754575AbeCGOhx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Mar 2018 09:37:53 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [for-4.16, V3,
 1/2] brcmfmac: add possibility to obtain firmware error
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1519848920-18000-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1519848920-18000-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20180307143752.4390660398@smtp.codeaurora.org> (sfid-20180307_153756_603576_995CE4C1)
Date: Wed,  7 Mar 2018 14:37:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> The feature module needs to evaluate the actual firmware error return
> upon a control command. This adds a flag to struct brcmf_if that the
> caller can set. This flag is checked to determine the error code that
> needs to be returned.
> 
> Fixes: b69c1df47281 ("brcmfmac: separate firmware errors from i/o errors")
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

2 patches applied to wireless-drivers.git, thanks.

933897342d07 brcmfmac: add possibility to obtain firmware error
455f3e76cfc0 brcmfmac: fix P2P_DEVICE ethernet address generation

-- 
https://patchwork.kernel.org/patch/10249603/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
