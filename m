Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60862 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750843AbdAaHHJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 02:07:09 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V2] rtlwifi: rtl8192ce: Fix loading of incorrect firmware
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170130214136.28170-1-Larry.Finger@lwfinger.net>
References: <20170130214136.28170-1-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Jurij Smakov <jurij@wooyd.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Message-Id: <20170131070601.9DEE860795@smtp.codeaurora.org> (sfid-20170131_080719_048605_F3D0EFF3)
Date: Tue, 31 Jan 2017 07:06:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> From: Jurij Smakov <jurij@wooyd.org>
> 
> In commit cf4747d7535a ("rtlwifi: Fix regression caused by commit
> d86e64768859, an error in the edit results in the wrong firmware
> being loaded for some models of the RTL8188/8192CE. In this condition,
> the connection suffered from high ping latency, slow transfer rates,
>  and required higher signal strengths to work at all
> 
> See https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=853073,
> https://bugzilla.opensuse.org/show_bug.cgi?id=1017471, and
> https://github.com/lwfinger/rtlwifi_new/issues/203 for descriptions
> of the problems. This patch fixes all of those problems.
> 
> Fixes: cf4747d7535a ("rtlwifi: Fix regression caused by commit d86e64768859")
> Signed-off-by: Jurij Smakov <jurij@wooyd.org>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org> # 4.9+

Patch applied to wireless-drivers.git, thanks.

52f5631a4c05 rtlwifi: rtl8192ce: Fix loading of incorrect firmware

-- 
https://patchwork.kernel.org/patch/9546113/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
