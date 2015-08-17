Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36632 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608AbbHQOtT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 10:49:19 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Fill in wmi 10.4 command handlers for addba/delba debug commands
References: <1439480454-31214-1-git-send-email-vthiagar@qti.qualcomm.com>
Date: Mon, 17 Aug 2015 17:49:13 +0300
In-Reply-To: <1439480454-31214-1-git-send-email-vthiagar@qti.qualcomm.com>
	(Vasanthakumar Thiagarajan's message of "Thu, 13 Aug 2015 21:10:54
	+0530")
Message-ID: <87a8tqdl7a.fsf@kamboji.qca.qualcomm.com> (sfid-20150817_164924_353304_220F850D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> writes:

> WMI 10.4 uses the same command interface as QCA988X for addba/delba
> debug wmi commands. Fill wmi_10_4_ops table with the functions used
> for QCA988X for these commands.
>
> With this change, the following debugfs entries can be used to
> configure the aggregation mode and to send addba request,
> addba response and delba respectively in manual aggregation mode
> for QCA99X0 chip.
>
> /sys/kernel/debug/ieee80211/phyX/netdev:wlanX/stations/XX:XX:XX:XX:XX:XX/aggr_mode
> /sys/kernel/debug/ieee80211/phyX/netdev:wlanX/stations/XX:XX:XX:XX:XX:XX/addba
> /sys/kernel/debug/ieee80211/phyX/netdev:wlanX/stations/XX:XX:XX:XX:XX:XX/addba_resp
> /sys/kernel/debug/ieee80211/phyX/netdev:wlanX/stations/XX:XX:XX:XX:XX:XX/delba
>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
