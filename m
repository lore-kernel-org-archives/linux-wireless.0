Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45932 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbbJFOkE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2015 10:40:04 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, shaofu <shaofu@realtek.com>
Subject: Re: [PATCH] rtlwifi: rtl818x: Move drivers into new realtek directory
References: <1441659556-20344-1-git-send-email-Larry.Finger@lwfinger.net>
Date: Tue, 06 Oct 2015 17:39:58 +0300
In-Reply-To: <1441659556-20344-1-git-send-email-Larry.Finger@lwfinger.net>
	(Larry Finger's message of "Mon, 7 Sep 2015 15:59:16 -0500")
Message-ID: <87io6k12o1.fsf@kamboji.qca.qualcomm.com> (sfid-20151006_164016_073778_424A2A44)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> Now that a new mac80211-based driver for Realtek devices has been submitted,
> it is time to reorganize the directories. Rather than having directories
> rtlwifi and rtl818x be in drivers/net/wireless/, they will now be in
> drivers/net/wireless/realtek/. This change simplifies the directory
> structure, but does not result in any configuration changes that are
> visable to the user.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> Kalle,
>
> This patch was generated aginst the pending branch of the wireless-drivers-next
> git tree.

Actually I prefer to use the master branch as the baseline for new
patches (I always rebase the pending branch) and because of that there
was a small conflict in drivers/net/wireless/Kconfig. Also I did a small
whitespace fix to realtek/rtlwifi/Kconfig. Please double check my
changes before I commit this:

https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?h=pending&id=38d9ef794a3edee89c6001e576ca9000db1a19d8

-- 
Kalle Valo
