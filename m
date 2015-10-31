Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:62146 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbbJaJih (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2015 05:38:37 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <c_traja@qti.qualcomm.com>
CC: <johannes@sipsolutions.net>, <ath10k@lists.infradead.org>,
	"Manikanta pubbisetty" <c_mpubbi@qti.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: set peer MFP flag in peer assoc command
References: <1444194961-12777-1-git-send-email-c_traja@qti.qualcomm.com>
Date: Sat, 31 Oct 2015 11:38:17 +0200
In-Reply-To: <1444194961-12777-1-git-send-email-c_traja@qti.qualcomm.com> (c.
	traja's message of "Wed, 7 Oct 2015 10:46:01 +0530")
Message-ID: <87pozvidiu.fsf@kamboji.qca.qualcomm.com> (sfid-20151031_103840_814989_6BDBFCD4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<c_traja@qti.qualcomm.com> writes:

> From: Tamizh chelvam <c_traja@qti.qualcomm.com>
>
> Set peer's management frame protection flag in peer assoc command,
> this setting will enable/disable encrytion of management frames in fw.
>
> Setting of this flag is based on whether MFP is enabled/disabled at STA
> and a firmware feature flag ATH10K_FW_FEATURE_MFP_SUPPORT. This is because
> only firmwares 10.1.561 and above have support for MFP.
>
> Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
> Signed-off-by: Manikanta pubbisetty <c_mpubbi@qti.qualcomm.com>

There was a trivial conflict, please check my conflict resolution in the
pending branch:

https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=c33d4ded1d2db2166c14afe602fe7ef645a5b16b

-- 
Kalle Valo
