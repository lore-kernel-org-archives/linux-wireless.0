Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50358 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757139Ab2CZN3S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 09:29:18 -0400
Message-ID: <4F706F28.4020302@qca.qualcomm.com> (sfid-20120326_152922_728132_7ED253AB)
Date: Mon, 26 Mar 2012 16:29:12 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Configure inactivity timeout in fw
References: <1332343719-3773-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1332343719-3773-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/21/2012 05:28 PM, Vasanthakumar Thiagarajan wrote:
> Configure the inactivity timeout passed in start_ap() to
> firmware. This capability is advertised only when fw supports
> it, there is a new bit (ATH6KL_FW_CAPABILITY_INACTIVITY_TIMEOUT)
> in firmware capability ie for driver to learn fw's capability.
> After the fw finds out the station is inactive, it will probe
> the station with null func frames. By default, the timeout is
> 10 secs.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, applied.

Kalle
