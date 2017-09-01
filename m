Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35217 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751715AbdIAUFA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 16:05:00 -0400
Received: by mail-wm0-f43.google.com with SMTP id v2so7432113wmf.0
        for <linux-wireless@vger.kernel.org>; Fri, 01 Sep 2017 13:04:59 -0700 (PDT)
Subject: Re: [PATCH v2] brcmfmac: feature check for multi-scheduled scan fails
 on bcm4345 devices
To: Ian W MORRISON <ianwmorrison@gmail.com>, kvalo@codeaurora.org,
        ian@mnementh.co.uk, linux-wireless@vger.kernel.org
References: <3cfcb175-8031-f5a8-da51-d81fa2d331c8@gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <7481b892-511f-4696-bf3f-82b1bec50abf@broadcom.com> (sfid-20170901_220504_594803_DFC3D80B)
Date: Fri, 1 Sep 2017 22:04:57 +0200
MIME-Version: 1.0
In-Reply-To: <3cfcb175-8031-f5a8-da51-d81fa2d331c8@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31-08-17 00:51, Ian W MORRISON wrote:
> The firmware feature check introduced for multi-scheduled scan is also
> failing for bcm4345 devices resulting in a firmware crash.
> The reason for this crash has not yet been root cause so this patch avoids
> the feature check for those device as a short-term fix.

Thanks. This is one of the few devices that I actually do not have on my 
desk.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Fixes: 9fe929aaace6 ("brcmfmac: add firmware feature detection for gscan feature")
> Signed-off-by: Ian W MORRISON <ianwmorrison@gmail.com>
> ---
> v2: Fixed tabs being replaced by spaces in patch submission
> Tested on MINIX NEO Z83-4 and MINIX NEO Z83-4 Pro devices.
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
