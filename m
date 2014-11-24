Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:60463 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414AbaKXLAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 06:00:53 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Vivek Natarajan <nataraja@qti.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath: Fix a false radar detection pattern
References: <1416821930-3003-1-git-send-email-nataraja@qti.qualcomm.com>
	<1416821930-3003-2-git-send-email-nataraja@qti.qualcomm.com>
Date: Mon, 24 Nov 2014 13:00:47 +0200
In-Reply-To: <1416821930-3003-2-git-send-email-nataraja@qti.qualcomm.com>
	(Vivek Natarajan's message of "Mon, 24 Nov 2014 15:08:50 +0530")
Message-ID: <8761e47ti8.fsf@kamboji.qca.qualcomm.com> (sfid-20141124_120058_989617_299A3648)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <nataraja@qti.qualcomm.com> writes:

> For FCC and JP, in one of the radar patterns, PPB and PRF seems to be
> interchanged leading to frequent incorrect radar detections.
>
> Signed-off-by: Vivek Natarajan <nataraja@qti.qualcomm.com>
> ---
>  drivers/net/wireless/ath/dfs_pattern_detector.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Better to send patches to ath.ko separately from ath10k patches as John
applies ath.ko patches (unless ath10k patches depend on the ath.ko
patches).

-- 
Kalle Valo
