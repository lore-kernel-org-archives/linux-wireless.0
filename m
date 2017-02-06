Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54556 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751524AbdBFMpq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 07:45:46 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        shaofu <shaofu@realtek.com>
Subject: Re: [PATCH 01/11 V3] rtlwifi: Fix programing CAM content sequence.
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
        <20170120212716.29887-1-Larry.Finger@lwfinger.net>
        <20170120212716.29887-1-Larry.Finger@lwfinger.net>
        <20170120212716.29887-2-Larry.Finger@lwfinger.net>
Date: Mon, 06 Feb 2017 14:45:41 +0200
In-Reply-To: <20170120212716.29887-2-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Fri, 3 Feb 2017 11:32:22 -0600")
Message-ID: <87bmufa3nu.fsf@codeaurora.org> (sfid-20170206_134558_961216_D69172C4)
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
> V3 - no changes

I missed in my reply to v2 that you had already sent v3 from this
patchset. Strange that I don't see this v3 patchset either in patchwork,
only v1.

Try submitting v4 in case it was just a temporary glitch in patchwork.
But if that doesn't help I'll apply these manually.

-- 
Kalle Valo
