Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44250 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754040AbdA3TKX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jan 2017 14:10:23 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Jurij Smakov <jurij@wooyd.org>,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: rtl8192ce: Fix loading of incorrect firmware
References: <20170130174057.7681-1-Larry.Finger@lwfinger.net>
Date: Mon, 30 Jan 2017 21:10:14 +0200
In-Reply-To: <20170130174057.7681-1-Larry.Finger@lwfinger.net> (Larry Finger's
        message of "Mon, 30 Jan 2017 11:40:57 -0600")
Message-ID: <87k29cqs89.fsf@kamboji.qca.qualcomm.com> (sfid-20170130_201041_515850_8F75A465)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> In commit cf4747d7535a ("rtlwifi: Fix regression caused by commit
> d86e64768859, an error in the edit results in the wrong firmware
> being loaded for some models of the RTL8188/8192CE.
>
> Fixes: cf4747d7535a ("rtlwifi: Fix regression caused by commit d86e64768859")
> Signed-off-by: Jurij Smakov <jurij@wooyd.org>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

This patch is written by Jurij, right? So then there should be a From
line in the commit log making him the author. An example here from Luca
where Sara is the author:

https://patchwork.kernel.org/patch/9544763/

> Cc: Stable <stable@vger.kernel.org>

You could add "# 4.9" here to make Greg's life easier. And no need to CC
stable in the email headers, having it in the commit log is enough.

> Kalle,
>
> This patch should be pushed upstream as soon as possible. Note that it
> does not cause a kernel panic. It does, however, reduce the reliability
> of the wireless connection.

Yeah, this looks like to be valid for 4.10 still. But please mention in
the commit log about the bug symptoms (reliability problems etc).

-- 
Kalle Valo
