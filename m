Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:13169 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab3KOJHI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 04:07:08 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: clear tx status before submitting to mac80211
References: <1384421658-7295-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 15 Nov 2013 11:06:55 +0200
In-Reply-To: <1384421658-7295-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 14 Nov 2013 10:34:18 +0100")
Message-ID: <87eh6i3ufk.fsf@kamboji.qca.qualcomm.com> (sfid-20131115_100714_402974_A6D16D09)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Garbage was reported in ieee80211_tx_info. This
> led to a WARN_ON in cfg80211_calculate_bitrate().
>
> This also fixes some random tx bitrate values
> reported through `iw` command.
>
> Reported-By: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
