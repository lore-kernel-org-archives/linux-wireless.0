Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15689 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3JHSz5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 14:55:57 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix station authorization
References: <1380875428-20899-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 8 Oct 2013 21:55:52 +0300
In-Reply-To: <1380875428-20899-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 4 Oct 2013 10:30:28 +0200")
Message-ID: <8761t7sibr.fsf@kamboji.qca.qualcomm.com> (sfid-20131008_205603_181870_7477800A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Peer authorization should be delayed until
> mac80211 says given station has transitioned into
> authorized state.
>
> The state is propagated from mac80211 for both
> open and protected networks.
>
> This should prevent data traffic to/from given
> station until authorization completes. Until now
> it was probably possible for unauthorized traffic
> to pass leading to possible security issues.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
