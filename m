Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:4335 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbbDQGfc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2015 02:35:32 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: change static wep key handling for client mode
References: <1428671158-8159-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 17 Apr 2015 09:35:23 +0300
In-Reply-To: <1428671158-8159-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 10 Apr 2015 13:05:58 +0000")
Message-ID: <87mw2745zo.fsf@kamboji.qca.qualcomm.com> (sfid-20150417_083535_596706_5E8BFDF2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> mac80211 sets static WEP keys as groupwise while
> firmware requires them to be installed twice as
> both pairwise and groupwise.
>
> Until now these keys were installed once as
> pairwise only and, due to that special handling,
> needed additional tricks to support 802.1x as
> well.
>
> Without this patch in some cases (when AP and
> ath10k client use different default tx keys)
> multicast communication was broken.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
