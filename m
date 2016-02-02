Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39700 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbcBBLWY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 06:22:24 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: do not limit the number of DFS channel interfaces to 1
References: <1453424190-64499-1-git-send-email-nbd@openwrt.org>
Date: Tue, 02 Feb 2016 13:22:17 +0200
In-Reply-To: <1453424190-64499-1-git-send-email-nbd@openwrt.org> (Felix
	Fietkau's message of "Fri, 22 Jan 2016 01:56:30 +0100")
Message-ID: <87io27gxw6.fsf@kamboji.qca.qualcomm.com> (sfid-20160202_122227_210109_B077B659)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@openwrt.org> writes:

> I think this limit was added when CSA with multiple interfaces wasn't
> working yet. It should no longer be necessary
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Applied to ath.git, thanks.

-- 
Kalle Valo
