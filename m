Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53106 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbbLKITS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 03:19:18 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	nbd@openwrt.org
Subject: Re: [PATCH v2 11/13] ath9k: MCC add sta_ap_ratio module param
References: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
	<1448613438-5173-11-git-send-email-janusz.dziedzic@tieto.com>
Date: Fri, 11 Dec 2015 10:19:10 +0200
In-Reply-To: <1448613438-5173-11-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Fri, 27 Nov 2015 09:37:16 +0100")
Message-ID: <87zixh5rep.fsf@kamboji.qca.qualcomm.com> (sfid-20151211_091922_156465_322308A5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> In case of MCC we can setup STA/AP(GO) ratio.
> Eg. setting sta_ap_ratio=80
> STA will get 80% of time, while AP(GO) 20%.
> Setup correct ctwindow.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Why? What's the use case?

And isn't there a better way to do this? Like using nl80211 (via
wpasupplicant?) or debugfs?

-- 
Kalle Valo
