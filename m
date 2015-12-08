Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37541 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbbLHO5v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 09:57:51 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: fix RTS/CTS by using proper rate flags
References: <1447945488-13665-1-git-send-email-me@bobcopeland.com>
Date: Tue, 08 Dec 2015 16:57:45 +0200
In-Reply-To: <1447945488-13665-1-git-send-email-me@bobcopeland.com> (Bob
	Copeland's message of "Thu, 19 Nov 2015 10:04:48 -0500")
Message-ID: <87fuzd9edy.fsf@kamboji.qca.qualcomm.com> (sfid-20151208_155754_113282_C0416F8A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> The rates in the tx control rateset do not have the protection
> flags applied, so RTS/CTS would never get enabled if requested.
>
> Fix by using the rate flags in the rates returned by
> ieee80211_get_tx_rates().
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

Applied, thanks.

-- 
Kalle Valo
