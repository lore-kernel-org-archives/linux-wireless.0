Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3767 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbcBBLTN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 06:19:13 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/5] ath10k: add basic hostq support
References: <1452693668-30030-1-git-send-email-michal.kazior@tieto.com>
	<1453382007-24622-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 2 Feb 2016 13:19:03 +0200
In-Reply-To: <1453382007-24622-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 21 Jan 2016 14:13:22 +0100")
Message-ID: <87r3gvgy1k.fsf@kamboji.qca.qualcomm.com> (sfid-20160202_121916_131962_AA98E50F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> There's a new firmware feature which uses a shared
> DMA memory so host can share it's per-sta per-tid
> queue size which is then subsequently used for
> firmware to assist in deciding which frames to put
> on the intermediate host-device tx queue.
>
> This patchset adds only basic support to make
> the firmware supporting the feature happy and
> running at all. Without it firmware would freeze
> shortly after booting.
>
> More patches will follow some time later to add
> the "new data path" logic.
>
>
> v2:
>  * fix gfp allocation [Ben]
>
>
> Michal Kazior (5):
>   ath10k: rename some HTT events
>   ath10k: add new htt definitions
>   ath10k: add new FW_FEATURE_PEER_FLOW_CONTROL
>   ath10k: clean up cont frag desc init code
>   ath10k: implement basic support for new tx path firmware

Applied, thanks.

-- 
Kalle Valo
