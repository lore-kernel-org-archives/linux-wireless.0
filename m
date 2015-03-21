Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59194 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbbCUInn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2015 04:43:43 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	nbd@openwrt.org, adrian@freebsd.org
Subject: Re: [PATCH 16/18 v2] ath9k: use REG_RMW and rmw buffer in ath9k_hw_4k_set_gain
References: <550C19E1.1020305@openwrt.org>
	<1426925257-15130-1-git-send-email-linux@rempel-privat.de>
Date: Sat, 21 Mar 2015 10:43:35 +0200
In-Reply-To: <1426925257-15130-1-git-send-email-linux@rempel-privat.de>
	(Oleksij Rempel's message of "Sat, 21 Mar 2015 09:07:37 +0100")
Message-ID: <87384yg2q0.fsf@kamboji.qca.qualcomm.com> (sfid-20150321_094400_791767_4094EE83)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oleksij Rempel <linux@rempel-privat.de> writes:

> it is possible to reduce time needed for this function
> by rplacing REG_WRITE with REG_RMW (plus dummy 0) and putt all commands
> in same buffer.
>
> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>

Please resend the whole patchset, much more reliable that way.

-- 
Kalle Valo
