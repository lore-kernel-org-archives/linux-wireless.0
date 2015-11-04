Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:4635 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbbKDSAW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 13:00:22 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 0/3] Fix few WMI/HTT interfaces
References: <1446638737-7953-1-git-send-email-vthiagar@qti.qualcomm.com>
Date: Wed, 4 Nov 2015 19:59:39 +0200
In-Reply-To: <1446638737-7953-1-git-send-email-vthiagar@qti.qualcomm.com>
	(Vasanthakumar Thiagarajan's message of "Wed, 4 Nov 2015 17:35:34
	+0530")
Message-ID: <87h9l1bq7o.fsf@kamboji.qca.qualcomm.com> (sfid-20151104_190031_731699_8BBFFC4E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> writes:

> This patch set fixes mismatch in peer_assoc complete wmi command for
> version 10.4 and peer_id configuration for HTT version < 3.4.
>
> V2:
> 	- Add cover letter
> 	- Rename ath10k_mac_need_offchan_tx_work() to
> 	  ath10k_mac_tx_frm_has_freq(). Add htt-op-version check
> 	  to the helper and use it in ath10k_htt_tx() while configuring
> 	  peerid.
>
> Vasanthakumar Thiagarajan (3):
>   ath10k: Fix peer assoc complete WMI command for 10.4
>   ath10k: Rename the helper which is used for off-channel tx
>   ath10k: Fix peerid configuration in htt tx desc for htt version < 3.4

These had a conflict but you didn't use ath.git as the baseline so I
can't easily fix them. Please try always to use clean ath.git master
branch as the baseline for your patches.

Applying: ath10k: Fix peer assoc complete WMI command for 10.4
fatal: sha1 information is lacking or useless (drivers/net/wireless/ath/ath10k/wmi.h).
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0001 ath10k: Fix peer assoc complete WMI command for 10.4

-- 
Kalle Valo
