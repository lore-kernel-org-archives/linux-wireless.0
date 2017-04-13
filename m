Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45724 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750745AbdDMOHn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 10:07:43 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/6] brcmfmac: rename brcmf_fws_{de, }init to brcmf_fws{at,
 de}tach
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1491480882-13877-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1491480882-13877-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20170413140743.2E67460AA0@smtp.codeaurora.org> (sfid-20170413_160747_765916_26A8E34A)
Date: Thu, 13 Apr 2017 14:07:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> This is a non-functional change to align the fwsignal module to
> the naming pattern used throughout the driver.
> 
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

6 patches applied to wireless-drivers-next.git, thanks.

ffb9f18ad8f0 brcmfmac: rename brcmf_fws_{de,}init to brcmf_fws{at,de}tach
fc0471e3e884 brcmfmac: ignore interfaces when fwsignal is disabled
acf8ac41dd73 brcmfmac: remove reference to fwsignal data from struct brcmf_pub
4835f37e3baf brcmfmac: add length checks in scheduled scan result handler
6594e1e83436 brcmfmac: remove bogus check in scheduled scan result handler
6ea51fc708ae brcmfmac: only add channels and ssids once in scan request

-- 
https://patchwork.kernel.org/patch/9666943/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
