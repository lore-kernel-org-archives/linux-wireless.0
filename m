Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:39320 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbbEVIRA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2015 04:17:00 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Fix survey information reporting
References: <1430829048-22549-1-git-send-email-vthiagar@qti.qualcomm.com>
Date: Fri, 22 May 2015 11:16:48 +0300
In-Reply-To: <1430829048-22549-1-git-send-email-vthiagar@qti.qualcomm.com>
	(Vasanthakumar Thiagarajan's message of "Tue, 5 May 2015 18:00:48
	+0530")
Message-ID: <87pp5t58nj.fsf@kamboji.qca.qualcomm.com> (sfid-20150522_101708_630529_8590875E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> writes:

> Rx clear count reported in wmi_chan_info_event is actually channel_busy_count
> not rx_frame_count. Send rx_clear_count through time_busy of survey_info
> and set SURVEY_INFO_TIME_BUSY in filled.
>
> iw wlan0 survey dump
>
> urvey data from wlan0
>         frequency:                      5180 MHz [in use]
>         noise:                          -103 dBm
>         channel active time:            150 ms
>         channel busy time:              22 ms
> Survey data from wlan0
>         frequency:                      5200 MHz
>         noise:                          -102 dBm
>         channel active time:            146 ms
>         channel busy time:              0 ms
>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>

Thanks, applied.

I actually applied this already on the 11th but apparently forgot to
send an email.

-- 
Kalle Valo
