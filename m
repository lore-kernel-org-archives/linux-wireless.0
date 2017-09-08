Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50052 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752210AbdIHJZ6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 05:25:58 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] brcmfmac: feature check for multi-scheduled scan fails on
 bcm4345 devices
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <3cfcb175-8031-f5a8-da51-d81fa2d331c8@gmail.com>
References: <3cfcb175-8031-f5a8-da51-d81fa2d331c8@gmail.com>
To: Ian W MORRISON <ianwmorrison@gmail.com>
Cc: arend.vanspriel@broadcom.com, ian@mnementh.co.uk,
        linux-wireless@vger.kernel.org
Message-Id: <20170908092558.0B31B601A0@smtp.codeaurora.org> (sfid-20170908_112602_270099_F64E47A4)
Date: Fri,  8 Sep 2017 09:25:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ian W MORRISON <ianwmorrison@gmail.com> wrote:

> The firmware feature check introduced for multi-scheduled scan is also
> failing for bcm4345 devices resulting in a firmware crash.
> The reason for this crash has not yet been root cause so this patch avoids
> the feature check for those device as a short-term fix.
> 
> Fixes: 9fe929aaace6 ("brcmfmac: add firmware feature detection for gscan feature")
> Cc: <stable@vger.kernel.org> # v4.13
> Signed-off-by: Ian W MORRISON <ianwmorrison@gmail.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers.git, thanks.

f957dd3c8db2 brcmfmac: feature check for multi-scheduled scan fails on bcm4345 devices

-- 
https://patchwork.kernel.org/patch/9930929/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
