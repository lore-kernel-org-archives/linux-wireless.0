Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51310 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194AbbBJOKG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2015 09:10:06 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [V2, for, 3.19,
 1/7] rtlwifi: Remove logging statement that is no longer needed
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1421773286-1039-2-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org, Stable <stable@vger.kernel.org>
Message-Id: <20150210141006.3A232140EB6@smtp.codeaurora.org> (sfid-20150210_151020_315445_4DC0B783)
Date: Tue, 10 Feb 2015 14:10:06 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> In commit e9538cf4f907 ("rtlwifi: Fix error when accessing unmapped memory
> in skb"), a printk was included to indicate that the condition had been
> reached. There is now enough evidence from other users that the fix is
> working. That logging statement can now be removed.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org> [V3.18]

Thanks, applied to wireless-drivers.git.

Kalle Valo
