Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53016 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751565AbeD3KmJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 06:42:09 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/6] brcmfmac: check p2pdev mac address uniqueness
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1524737811-1965-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1524737811-1965-1-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20180430104208.EC5FE607CF@smtp.codeaurora.org> (sfid-20180430_124213_162228_8ED046A8)
Date: Mon, 30 Apr 2018 10:42:08 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> The mac address for p2pdev must be different from the primary interface
> due to firmware requirement. Add an explicit check for this requirement
> if user-space provides a mac address.
> 
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

cb746e47837a brcmfmac: check p2pdev mac address uniqueness

-- 
https://patchwork.kernel.org/patch/10365333/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
