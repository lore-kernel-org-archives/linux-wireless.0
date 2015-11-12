Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43741 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbbKLTyf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 14:54:35 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] realtek: rtlwifi: rtl8821ae: Fix lockups on boot
References: <1447173971-15311-1-git-send-email-Larry.Finger@lwfinger.net>
Date: Thu, 12 Nov 2015 21:54:28 +0200
In-Reply-To: <1447173971-15311-1-git-send-email-Larry.Finger@lwfinger.net>
	(Larry Finger's message of "Tue, 10 Nov 2015 10:46:11 -0600")
Message-ID: <87a8qj56yz.fsf@kamboji.qca.qualcomm.com> (sfid-20151112_205438_835662_A55C689B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> In commit 54328e64047a5 ("rtlwifi: rtl8821ae: Fix system lockups on boot"),
> an attempt was made to fix a regression introduced in commit 1277fa2ab2f9
> ("rtlwifi: Remove the clear interrupt routine from all drivers").
> Unfortunately, there were logic errors in that patch that prevented
> affected boxes from booting even after that patch was applied.
>
> The actual cause of the original problem is unknown as none of the
> developers have systems that are affected.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org> [V4.1+]

I think the "realtek:" prefix is superfluous, "rtlwifi:" should be
enough. I'll also add a fixes line before I commit this:

Fixes: 54328e64047a ("rtlwifi: rtl8821ae: Fix system lockups on boot")

-- 
Kalle Valo
