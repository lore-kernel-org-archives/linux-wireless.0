Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55197 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbbLANNd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 08:13:33 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	nbd@openwrt.org
Subject: Re: [PATCH v2 09/13] ath9k: request NOA update when chanctx active
References: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
	<1448613438-5173-9-git-send-email-janusz.dziedzic@tieto.com>
Date: Tue, 01 Dec 2015 15:13:26 +0200
In-Reply-To: <1448613438-5173-9-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Fri, 27 Nov 2015 09:37:14 +0100")
Message-ID: <87vb8igvm1.fsf@kamboji.qca.qualcomm.com> (sfid-20151201_141338_874928_54EE033B)
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

It would make my life a lot easier if you could submit patches like this
(which depend on something else) in a separate patchset instead of
hiding them inside a 13 patch set. I'll postpone this patch for now and
apply it once I have the mac80211 commit.

-- 
Kalle Valo
