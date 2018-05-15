Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51128 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752475AbeEOJcF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 05:32:05 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/8] brcmfmac: coredump functionality and fixes
References: <1526375691-31789-1-git-send-email-arend.vanspriel@broadcom.com>
Date: Tue, 15 May 2018 12:32:02 +0300
In-Reply-To: <1526375691-31789-1-git-send-email-arend.vanspriel@broadcom.com>
        (Arend van Spriel's message of "Tue, 15 May 2018 11:14:43 +0200")
Message-ID: <877eo5p8ml.fsf@kamboji.qca.qualcomm.com> (sfid-20180515_113211_687968_F264249B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> This series is intended for 4.18:
>
>  * fix variable initialization found by kbuild bot.
>  * make ALLFFMAC variable static.
>  * support user-space initiated coredump.
>
> The first two patches in this series apply to the master branch of the
> wireless-drivers-next repository. The remaining patches related to coredump
> functionality are dependent upon a commit present since v4.17-rc3:
>
>   commit ed4564babeeee4fb19fe4ec0beabe29754e380f9
>   Author: Arend van Spriel <aspriel@gmail.com>
>   Date:   Sun Apr 8 23:57:07 2018 +0200
>
>      drivers: change struct device_driver::coredump() return type to void
>
> Both w-d-next and bt-next (for patch 5/8) do not carry this patch yet.

So what I'm planning to do is apply patch 1 now to fix the warning, send
a pull request to Dave and then fast forward w-d-next so that I can
apply rest of the patches.

-- 
Kalle Valo
