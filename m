Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58178 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbbGKQRk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jul 2015 12:17:40 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/6] ath10k: random fixes 2015-07-09
References: <1436440119-30231-1-git-send-email-michal.kazior@tieto.com>
Date: Sat, 11 Jul 2015 19:17:34 +0300
In-Reply-To: <1436440119-30231-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 9 Jul 2015 13:08:33 +0200")
Message-ID: <87a8v2wtwh.fsf@kamboji.qca.qualcomm.com> (sfid-20150711_181748_675243_7C197A61)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> I've done most of the patches while testing P2P
> but they aren't limited to that scope.
>
> There are no inter-dependencies within the patchset
> so single patches should be easily cherry-pickable
> in case, e.g. some patches raise concerns or are
> decided to be dropped during review.
>
>
> Michal Kazior (6):
>   ath10k: don't set cck/ofdm scan flags
>   ath10k: limit multi-vif ps more aggresivelly
>   ath10k: fix hw roc expiration notifcation
>   ath10k: update vdev ps state on start
>   ath10k: fix per-vif queue locking
>   ath10k: tweak interface combinations

Thanks, all six applied.

-- 
Kalle Valo
