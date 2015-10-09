Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38899 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbbJIOdn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2015 10:33:43 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <c_mkenna@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
	Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Enable adaptive CCA
References: <1444210033-25901-1-git-send-email-c_mkenna@qti.qualcomm.com>
Date: Fri, 9 Oct 2015 17:33:28 +0300
In-Reply-To: <1444210033-25901-1-git-send-email-c_mkenna@qti.qualcomm.com> (c.
	mkenna's message of "Wed, 7 Oct 2015 14:57:13 +0530")
Message-ID: <87io6gqfgn.fsf@kamboji.qca.qualcomm.com> (sfid-20151009_163354_422473_11FCCF5F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<c_mkenna@qti.qualcomm.com> writes:

> From: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
>
> European Union has made it mandatory that all devices working in 2.4 GHz
> has to adhere to the ETSI specification (ETSI EN 300 328 V1.9.1)
> beginnig this year. The standard basically speaks about interferences
> in 2.4Ghz band.
> For example, when 802.11 device detects interference, TX must be stopped
> as long as interference is present.
>
> Adaptive CCA is a feature, when enabled the device learns from the
> environment and configures CCA levels adaptively. This will improve
> detecting interferences and the device can stop trasmissions till the
> interference is present eventually leading to good performances in
> varying interference conditions.
>
> The patch includes code for enabling adaptive CCA for 10.2.4 firmware on
> QCA988X.
>
> Signed-off-by: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
> Signed-off-by: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>

There are conflicts, please rebase and resend:

Applying: ath10k: Enable adaptive CCA
Using index info to reconstruct a base tree...
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/ath/ath10k/wmi.h
Auto-merging drivers/net/wireless/ath/ath10k/wmi.c
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi.c
Auto-merging drivers/net/wireless/ath/ath10k/wmi-ops.h
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-ops.h
Auto-merging drivers/net/wireless/ath/ath10k/mac.c
Auto-merging drivers/net/wireless/ath/ath10k/core.h
Failed to merge in the changes.
Patch failed at 0001 ath10k: Enable adaptive CCA

-- 
Kalle Valo
