Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35544 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751001AbdBFLvE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 06:51:04 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        shaofu <shaofu@realtek.com>
Subject: Re: [PATCH 01/11 V2] rtlwifi: Fix programing CAM content sequence.
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
        <20170120212716.29887-1-Larry.Finger@lwfinger.net>
        <20170120212716.29887-2-Larry.Finger@lwfinger.net>
Date: Mon, 06 Feb 2017 13:50:59 +0200
In-Reply-To: <20170120212716.29887-2-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Wed, 1 Feb 2017 14:48:03 -0600")
Message-ID: <87inona670.fsf@codeaurora.org> (sfid-20170206_125108_120922_C804D090)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> From: Ping-Ke Shih <pkshih@realtek.com>
>
> There is a potential race condition when the control byte of a CAM
> entry is written first. Write in reverse order to correct the condition.
>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: shaofu <shaofu@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> V2 - no changes

Weird, I don't see any of the v2 patches in patchwork:

https://patchwork.kernel.org/project/linux-wireless/list/?state=*&page=1

I do see other recent patches from you Larry, but not this set. Can you
resubmit, please?

-- 
Kalle Valo
