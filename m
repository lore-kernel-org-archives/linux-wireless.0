Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36732 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750803AbdFOQI5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 12:08:57 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [for-4.12,
 1/3] brcmfmac: add parameter to pass error code in firmware callback
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1497268054-4507-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1497268054-4507-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20170615160856.417AE60A97@smtp.codeaurora.org> (sfid-20170615_180900_365181_5087A339)
Date: Thu, 15 Jun 2017 16:08:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> Extend the parameters in the firmware callback so it can be called
> upon success and failure. This allows the caller to properly clear
> all resources in the failure path. Right now the error code is
> always zero, ie. success.
> 
> Cc: stable@vger.kernel.org # 4.9.x-
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

3 patches applied to wireless-drivers.git, thanks.

6d0507a777fb brcmfmac: add parameter to pass error code in firmware callback
03fb0e8393fa brcmfmac: use firmware callback upon failure to load
7a51461fc2da brcmfmac: unbind all devices upon failure in firmware callback

-- 
https://patchwork.kernel.org/patch/9780793/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
