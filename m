Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47226 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752148AbdHNIJr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Aug 2017 04:09:47 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [for-4.13] brcmfmac: feature check for multi-scheduled scan fails
 on bcm4343x devices
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1502446056-30035-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1502446056-30035-1-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20170814080947.1671560350@smtp.codeaurora.org> (sfid-20170814_100951_671452_4E0B0660)
Date: Mon, 14 Aug 2017 08:09:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> The firmware feature check introduced for multi-scheduled scan turned out
> to be failing for bcm4343{0,1,8} devices resulting in a firmware crash.
> The reason for this crash has not yet been root cause so this patch avoids
> the feature check for those device as a short-term fix.
> 
> Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
> Reported-by: Ian Molton <ian@mnementh.co.uk>
> Fixes: 9fe929aaace6 ("brcmfmac: add firmware feature detection for gscan feature")
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers.git, thanks.

e9bf53ab1ee3 brcmfmac: feature check for multi-scheduled scan fails on bcm4343x devices

-- 
https://patchwork.kernel.org/patch/9895411/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
