Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25439 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617AbaIZLGs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 07:06:48 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/4] ath10k: fix/cleanup fw stats
References: <1411641230-18785-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 26 Sep 2014 14:06:42 +0300
In-Reply-To: <1411641230-18785-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 25 Sep 2014 12:33:46 +0200")
Message-ID: <871tqy63p9.fsf@kamboji.qca.qualcomm.com> (sfid-20140926_130652_099584_F6F970A1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> This cleans up and fixes fw stats aggregation.
>
>
> Michal Kazior (4):
>   ath10k: split wmi stats parsing
>   ath10k: rename fw_stats related stuff
>   ath10k: request fw_stats once on open
>   ath10k: fix fw stats processing

I didn't review these yet but I saw new warnings:

drivers/net/wireless/ath/ath10k/debug.c: In function 'ath10k_fw_stats_fill':
drivers/net/wireless/ath/ath10k/debug.c:540:5: warning: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type 'size_t' [-Wformat]

drivers/net/wireless/ath/ath10k/wmi.c:1513: WARNING: else is not generally useful after a break or return

-- 
Kalle Valo
