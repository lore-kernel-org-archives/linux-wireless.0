Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:8573 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398AbaJXNge (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 09:36:34 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: call correct function for frag threshold
References: <1413980825-11186-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 24 Oct 2014 16:36:07 +0300
In-Reply-To: <1413980825-11186-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 22 Oct 2014 14:27:05 +0200")
Message-ID: <87ppdhmvy0.fsf@kamboji.qca.qualcomm.com> (sfid-20141024_153638_933832_192A4125)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Rts threshold was being configured instead of
> fragmentation threshold.
>
> Keep in mind available firmware binaries don't
> seem to support fragmentation anyway so this
> doesn't fix fragmentation threshold per se.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
