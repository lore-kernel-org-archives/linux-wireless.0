Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44371 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab3JHMYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 08:24:15 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix RX performance when using AP 10.X FW
References: <1381201236-17035-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 8 Oct 2013 15:24:09 +0300
In-Reply-To: <1381201236-17035-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 7 Oct 2013 20:00:36 -0700")
Message-ID: <87r4bwrlw6.fsf@kamboji.qca.qualcomm.com> (sfid-20131008_142417_732602_2322FC9A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Due to oversight AP 10.X support was merged with
> Ethernet RX decap mode.
>
> Only Native Wifi RX decap mode guarantees IP
> header is properly aligned and avoids sk_buff data
> realignment (which is very expensive
> performance-wise) in mac80211.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
