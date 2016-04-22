Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33692 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbcDVSVr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2016 14:21:47 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org,
	Oleksij Rempel <linux@rempel-privat.de>,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH] ath9k: remove repetitions of mask array size
In-Reply-To: <1460818477-22785-1-git-send-email-me@bobcopeland.com> (Bob
	Copeland's message of "Sat, 16 Apr 2016 10:54:37 -0400")
References: <1460818477-22785-1-git-send-email-me@bobcopeland.com>
Date: Fri, 22 Apr 2016 21:21:42 +0300
Message-ID: <87a8kly05l.fsf@purkki.adurom.net> (sfid-20160422_202206_126280_7A92B399)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> The constant "123", which is the number of elements in
> mask_m / mask_p, is repeated several times in this function.
>
> Replace memsets with array initialization, and replace a loop
> conditional with ARRAY_SIZE() so that we don't repeat ourselves.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

As this depends on a patch in wireless-drivers (at least I assume so),
and I cannot apply a cleanup patch like this to that repository, I'm
planning to apply this only after 4.7-rc1 is released. I hope that's ok.

-- 
Kalle Valo
