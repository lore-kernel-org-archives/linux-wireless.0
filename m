Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50712 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbbLKNdO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 08:33:14 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: greearb@candelatech.com
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] ath6kl:  fix tx/rx antenna reporting for 2x2 devices.
References: <1448924508-25672-1-git-send-email-greearb@candelatech.com>
Date: Fri, 11 Dec 2015 15:33:06 +0200
In-Reply-To: <1448924508-25672-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Mon, 30 Nov 2015 15:01:47
	-0800")
Message-ID: <87oadx3yb1.fsf@kamboji.qca.qualcomm.com> (sfid-20151211_143324_383044_58B4A88F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> My previous patch incorrectly reported the antenna
> for 2x2 devices.  It should be a mask instead of
> a numeric count.  This patch fixes that.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Both patches applied, thanks.

-- 
Kalle Valo
