Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:23320 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbbKLT0B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 14:26:01 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V3 0/3] Fix few WMI/HTT interfaces
References: <1446703440-13880-1-git-send-email-vthiagar@qti.qualcomm.com>
Date: Thu, 12 Nov 2015 21:25:41 +0200
In-Reply-To: <1446703440-13880-1-git-send-email-vthiagar@qti.qualcomm.com>
	(Vasanthakumar Thiagarajan's message of "Thu, 5 Nov 2015 11:33:57
	+0530")
Message-ID: <87r3jv58ay.fsf@kamboji.qca.qualcomm.com> (sfid-20151112_202605_552065_C504E7C0)
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
> V3:
> 	- Rebase on top of ath:master TOT
>
> Vasanthakumar Thiagarajan (3):
>   ath10k: Fix peer assoc complete WMI command for 10.4
>   ath10k: Rename the helper which is used for off-channel tx
>   ath10k: Fix peerid configuration in htt tx desc for htt version < 3.4

All three applied, thanks.

-- 
Kalle Valo
