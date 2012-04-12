Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12002 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab2DLHgA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 03:36:00 -0400
Message-ID: <4F8685DC.7040209@qca.qualcomm.com> (sfid-20120412_093605_997294_62BA8321)
Date: Thu, 12 Apr 2012 10:35:56 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Fix possible unaligned memory access in ath6kl_get_rsn_capab()
References: <1334045147-26773-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1334045147-26773-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/10/2012 11:05 AM, Vasanthakumar Thiagarajan wrote:
> alignment is not taken care in accessing pairwise cipher and AKM suite
> count which are parsed from rsn ie. Fix this alignment issue.
> 
> Reported-by: Joe Perches <joe@perches.com>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, applied.

Kalle
