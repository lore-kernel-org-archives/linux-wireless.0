Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41669 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965515AbcA1IVy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 03:21:54 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	nbd@openwrt.org
Subject: Re: [PATCH v2 09/13] ath9k: request NOA update when chanctx active
References: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
	<1448613438-5173-9-git-send-email-janusz.dziedzic@tieto.com>
Date: Thu, 28 Jan 2016 10:21:46 +0200
In-Reply-To: <1448613438-5173-9-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Fri, 27 Nov 2015 09:37:14 +0100")
Message-ID: <87si1im7vp.fsf@kamboji.qca.qualcomm.com> (sfid-20160128_092202_415346_66809E23)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Request NOA update when chanctx active, also in case
> of STA.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> ---
> This depends on:
> mac80211: add new IEEE80211_VIF_GET_NOA_UPDATE flag

The dependency is now in ath.git and I have applied this, thanks.

-- 
Kalle Valo
