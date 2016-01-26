Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:32487 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965184AbcAZPCw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 10:02:52 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/7] Add support for Per STA Rx duration
References: <1452699994-5078-1-git-send-email-mohammed@qca.qualcomm.com>
Date: Tue, 26 Jan 2016 17:02:35 +0200
In-Reply-To: <1452699994-5078-1-git-send-email-mohammed@qca.qualcomm.com>
	(Mohammed Shafi Shajakhan's message of "Wed, 13 Jan 2016 21:16:27
	+0530")
Message-ID: <87powopeno.fsf@kamboji.qca.qualcomm.com> (sfid-20160126_160255_021512_66096A63)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> writes:

> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>
> *Enable parsing of rx_duration as part of peer stats support
>  by the new 10.2.4 firmware
> *Add support to dump per STA rx_duration  (usecs)
> *Pre-requisite cleanups
> *For calculating total rx-duration in host, enable provision to
>  support periodic peer stats update.
> *Also enable mac80211 debugfs entry to track per STA rx duration(usecs)
>
> Mohammed Shafi Shajakhan (7):
>   ath10k: Add support for parsing per STA rx_duration for 10.2.4
>   ath10k: Fix naming Peer stats rssi_changed field in 10.2.4
>   ath10k: Cleanup setting pdev paramaters
>   ath10k: Rename few function names of firmware stats
>   ath10k: Provision to support periodic peer stats update
>   ath10k: Enable periodic peer stats update
>   ath10k: Add debugfs support for Per STA total rx duration

Applied, thanks.

-- 
Kalle Valo
