Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:58811 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbbKWPVm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 10:21:42 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 0/9] ath10k: clean up ath10k_skb_cb
References: <87mvuj585b.fsf@kamboji.qca.qualcomm.com>
	<1447826363-16818-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 23 Nov 2015 17:21:26 +0200
In-Reply-To: <1447826363-16818-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 18 Nov 2015 06:59:14 +0100")
Message-ID: <878u5ospvt.fsf@kamboji.qca.qualcomm.com> (sfid-20151123_162144_764395_9579E224)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The ath10k_skb_cb structure wasn't really space
> efficient. Some stuff is removed or replaced with
> more compact representation.
>
> This cleanup is necessary for future features.
>
> The size of ath10k_skb_cb:
>
>           before   after
>  x86-32   26       12
>  x86-64   34       20
>
>
> v3:
>  * rebase
>
> v2:
>  * fix a bug (patch 7/9 introduced)
>
>
> Michal Kazior (9):
>   ath10k: merge is_protected with nohwcrypt
>   ath10k: rename function to adhere to naming convention
>   ath10k: remove txmode from skb_cb
>   ath10k: remove is_offchan
>   ath10k: remove freq from skb_cb
>   ath10k: pack up flags in skb_cb
>   ath10k: fix tx header parsing
>   ath10k: replace vdev_id and tid in skb cb
>   ath10k: store msdu_id instead of txbuf pointers

Applied, thanks.

-- 
Kalle Valo
