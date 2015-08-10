Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60121 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbbHJTBz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 15:01:55 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, timlee <timlee@realtek.com>,
	shaofu <shaofu@realtek.com>
Subject: Re: [PATCH V3 NEXT 1/7] rtlwifi: rtl8821ae: Remove unsupported 5G channels
References: <1439052819-30196-1-git-send-email-Larry.Finger@lwfinger.net>
	<1439052819-30196-2-git-send-email-Larry.Finger@lwfinger.net>
Date: Mon, 10 Aug 2015 22:01:48 +0300
In-Reply-To: <1439052819-30196-2-git-send-email-Larry.Finger@lwfinger.net>
	(Larry Finger's message of "Sat, 8 Aug 2015 11:53:33 -0500")
Message-ID: <87zj1zt1b7.fsf@kamboji.qca.qualcomm.com> (sfid-20150810_210159_650410_FA277A50)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> From: timlee <timlee@realtek.com>
>
> The 5G channel list contains channels that are not supported. Previously
> there were two copies of the 5G channel arrays, one in hw.c and one in
> phy.c. These have been renamed to prevent namespace pollution, and made
> global. Now any further changes will only need to be in a single location.
>
> Signed-off-by: timlee <timlee@realtek.com>
> Signed-off-by: shaofu <shaofu@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

The Signed-off-by line should contain the real full name and, for
example, I doubt that "shaofu" really is a full name, it looks more like
a username for me. Can you fix these, please?

-- 
Kalle Valo
