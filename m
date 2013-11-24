Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45284 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3KXNwD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 08:52:03 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] ath10k: fix Tx status clearing
References: <1385126819-15311-1-git-send-email-michal.kazior@tieto.com>
	<1385126819-15311-4-git-send-email-michal.kazior@tieto.com>
Date: Sun, 24 Nov 2013 15:51:58 +0200
In-Reply-To: <1385126819-15311-4-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 22 Nov 2013 14:26:59 +0100")
Message-ID: <87fvqlsy9t.fsf@kamboji.qca.qualcomm.com> (sfid-20131124_145207_637777_D75A394E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Too much of tx info was being cleared. This caused
> issues in some setups.
>
> Reported-By: Matti Laakso <malaakso@elisanet.fi>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Please describe the issues (or at least some of them) in the commit log.
The idea is that an advanced ath10k user will understand what kind of
bug (from user's point of view) this patch is fixing.

-- 
Kalle Valo
