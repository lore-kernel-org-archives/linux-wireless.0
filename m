Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48084 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750776AbdAaG1t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 01:27:49 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Jurij Smakov <jurij@wooyd.org>
Subject: Re: [PATCH V2] rtlwifi: rtl8192ce: Fix loading of incorrect firmware
References: <20170130214136.28170-1-Larry.Finger@lwfinger.net>
Date: Tue, 31 Jan 2017 08:27:35 +0200
In-Reply-To: <20170130214136.28170-1-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Mon, 30 Jan 2017 15:41:36 -0600")
Message-ID: <877f5brbfs.fsf@kamboji.qca.qualcomm.com> (sfid-20170131_072915_368707_FF47F82A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

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
> ---
> V2 - answer the comments of Kalle

Perfect, thanks. Now it should be obvious why this patch needs to be in
4.10.

-- 
Kalle Valo
