Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:16672 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbbKDH5i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 02:57:38 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "Raja, Tamizh Chelvam" <c_traja@qti.qualcomm.com>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH 2/2] ath10k: set peer MFP flag in peer assoc command
References: <1444194961-12777-1-git-send-email-c_traja@qti.qualcomm.com>
	<87pozvidiu.fsf@kamboji.qca.qualcomm.com>
	<39ba89200efb4ef0a2f5ccd5aca878a6@aphydexm01b.ap.qualcomm.com>
Date: Wed, 4 Nov 2015 09:57:20 +0200
In-Reply-To: <39ba89200efb4ef0a2f5ccd5aca878a6@aphydexm01b.ap.qualcomm.com>
	(Tamizh Chelvam Raja's message of "Wed, 4 Nov 2015 05:20:43 +0000")
Message-ID: <87egg6dwnz.fsf@kamboji.qca.qualcomm.com> (sfid-20151104_085741_832741_CF5AC92D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Raja, Tamizh Chelvam" <c_traja@qti.qualcomm.com> writes:

>>> From: Tamizh chelvam <c_traja@qti.qualcomm.com>
>>>
>>> Set peer's management frame protection flag in peer assoc command, 
>>> this setting will enable/disable encrytion of management frames in fw.
>>>
>>> Setting of this flag is based on whether MFP is enabled/disabled at 
>>> STA and a firmware feature flag ATH10K_FW_FEATURE_MFP_SUPPORT. This is 
>>> because only firmwares 10.1.561 and above have support for MFP.
>>>
>>> Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
>>> Signed-off-by: Manikanta pubbisetty <c_mpubbi@qti.qualcomm.com>
>
>>There was a trivial conflict, please check my conflict resolution in the pending branch:
>
>>https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=c33d4ded1d2db2166c14afe602fe7ef645a5b16b
>
>
> When I try to apply this patch. I got following conflict.
>
> Checking patch drivers/net/wireless/ath/ath10k/core.c...
> Checking patch drivers/net/wireless/ath/ath10k/core.h...
> Hunk #1 succeeded at 512 (offset -1 lines).
> Checking patch drivers/net/wireless/ath/ath10k/htt_tx.c...
> Checking patch drivers/net/wireless/ath/ath10k/mac.c...
> error: while searching for:

I don't know what you are trying to do, but I apply the patches from the
pending branch to ath-next. You might get a conflict if you apply the
patch to another branch.

-- 
Kalle Valo
