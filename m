Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59338 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751545AbdHKKaq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Aug 2017 06:30:46 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH for-4.13] brcmfmac: feature check for multi-scheduled scan fails on bcm4343x devices
References: <1502446056-30035-1-git-send-email-arend.vanspriel@broadcom.com>
Date: Fri, 11 Aug 2017 13:30:41 +0300
In-Reply-To: <1502446056-30035-1-git-send-email-arend.vanspriel@broadcom.com>
        (Arend van Spriel's message of "Fri, 11 Aug 2017 11:07:36 +0100")
Message-ID: <87378yflbi.fsf@kamboji.qca.qualcomm.com> (sfid-20170811_123052_181771_BC1E6B4F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> The firmware feature check introduced for multi-scheduled scan turned out
> to be failing for bcm4343{0,1,8} devices resulting in a firmware crash.
> The reason for this crash has not yet been root cause so this patch avoids
> the feature check for those device as a short-term fix.
>
> Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
> Reported-by: Ian Molton <ian@mnementh.co.uk>
> Fixes: 9fe929aaace6 ("brcmfmac: add firmware feature detection for gscan feature")
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

So the first release for 9fe929aaace6 was v4.13-rc1 so no stable tag
needed.

(This is mostly to remind myself about this :)

-- 
Kalle Valo
