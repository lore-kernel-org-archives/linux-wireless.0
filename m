Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39407 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbcEISN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 14:13:58 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com, Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH] ath9k: Fix symbol overlap window for half/quarter channels
References: <1461935194-19632-1-git-send-email-helmut.schaa@googlemail.com>
Date: Mon, 09 May 2016 21:13:44 +0300
In-Reply-To: <1461935194-19632-1-git-send-email-helmut.schaa@googlemail.com>
	(Helmut Schaa's message of "Fri, 29 Apr 2016 15:06:34 +0200")
Message-ID: <87a8jzhzfr.fsf@kamboji.qca.qualcomm.com> (sfid-20160509_201400_679293_3FC6FDA4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa <helmut.schaa@googlemail.com> writes:

> Since commit cd6cfd7311a385144a2f9c74f692ae2df3ae033f
> "ath9k: do not set half/quarter channel flags in AR_PHY_MODE" the
> condition "rfMode & (AR_PHY_MODE_QUARTER | AR_PHY_MODE_HALF)" would
> never evaluate to true.
>
> Fix this by using the available IS_CHAN_HALF_RATE and IS_CHAN_QUARTER_RATE
> marcros instead.
>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> Cc: Felix Fietkau <nbd@openwrt.org>

Thanks, applied to ath.git.

-- 
Kalle Valo
