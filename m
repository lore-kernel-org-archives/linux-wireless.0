Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9024 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2D0Gqh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2012 02:46:37 -0400
Message-ID: <4F9A40C6.5040305@qca.qualcomm.com> (sfid-20120427_084640_569730_6704B97F)
Date: Fri, 27 Apr 2012 09:46:30 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Fix bss filter setting while scanning
References: <1335337746-7294-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1335337746-7294-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/25/2012 10:09 AM, Vasanthakumar Thiagarajan wrote:
> bss filter is configured to allow the frames from all the bss other
> than the currenly connected one, this is done when a scan is requested
> in connected state. There is no reason to filter out the currently
> connected bss, configure the filter to allow all the bss. This would
> fix the reporting of stale rssi of the current bss while scanning.
> 
> Reported-by: Naveen singh <navesing@qca.qualcomm.com>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, applied.

Kalle
