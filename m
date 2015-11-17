Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50490 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbbKQN72 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2015 08:59:28 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl8821ae: Fix lockups on boot
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1447173971-15311-1-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stable <stable@vger.kernel.org>
Message-Id: <20151117135927.6B71A141099@smtp.codeaurora.org> (sfid-20151117_145932_380732_79769B5D)
Date: Tue, 17 Nov 2015 13:59:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> In commit 54328e64047a5 ("rtlwifi: rtl8821ae: Fix system lockups on boot"),
> an attempt was made to fix a regression introduced in commit 1277fa2ab2f9
> ("rtlwifi: Remove the clear interrupt routine from all drivers").
> Unfortunately, there were logic errors in that patch that prevented
> affected boxes from booting even after that patch was applied.
> 
> The actual cause of the original problem is unknown as none of the
> developers have systems that are affected.
> 
> Fixes: 54328e64047a ("rtlwifi: rtl8821ae: Fix system lockups on boot")
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org> [V4.1+]

Thanks, applied to wireless-drivers.git.

Kalle Valo
