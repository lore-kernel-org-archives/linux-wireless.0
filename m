Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60722 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752045AbdFMGMg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 02:12:36 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [for-4.12,
 3/3] brcmfmac: unbind all devices upon failure in firmware callback
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1497268054-4507-4-git-send-email-arend.vanspriel@broadcom.com>
References: <1497268054-4507-4-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20170613061235.E0D89607C4@smtp.codeaurora.org> (sfid-20170613_081358_250421_BA39A7D0)
Date: Tue, 13 Jun 2017 06:12:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> In brcmf_sdio_firmware_callback() we need to unbind the driver from
> both sdio_func devices.
> 
> Cc: stable@vger.kernel.org # 4.9.x-
> Tested-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

The commit log doesn't really describe the bug you are fixing (ie. doesn't
answer "why?"). Can you give some more info, logs etc (as a reply to this mail)
and I'll add it.

-- 
https://patchwork.kernel.org/patch/9780797/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
