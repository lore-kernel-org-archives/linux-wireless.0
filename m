Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51915 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab2IUQfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 12:35:38 -0400
Message-ID: <505C9746.4060009@qca.qualcomm.com> (sfid-20120921_183542_482296_7C1CE9DB)
Date: Fri, 21 Sep 2012 19:35:18 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 1/4] ath6kl: Fix bug in scheduling hb_timer
References: <1346656777-15197-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1346656777-15197-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/03/2012 10:19 AM, Vasanthakumar Thiagarajan wrote:
> hb_timer should be scheduled only when hb_poll is non-zero.
> But in ath6kl_recovery_work() the timer is scheduled based
> on fw_recovery.enable instead which is wrong.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, all four applied.

Kalle
