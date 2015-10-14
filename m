Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37604 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbJNKn7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 06:43:59 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, shaofu <shaofu@realtek.com>
Subject: Re: [PATCH] rtlwifi: rtl818x: Move drivers into new realtek directory
References: <1441659556-20344-1-git-send-email-Larry.Finger@lwfinger.net>
Date: Wed, 14 Oct 2015 13:43:53 +0300
In-Reply-To: <1441659556-20344-1-git-send-email-Larry.Finger@lwfinger.net>
	(Larry Finger's message of "Mon, 7 Sep 2015 15:59:16 -0500")
Message-ID: <87twptn312.fsf@kamboji.qca.qualcomm.com> (sfid-20151014_124409_002895_3E43D3A9)
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

Manually applied to wireless-drivers-next.git, thanks.

-- 
Kalle Valo
