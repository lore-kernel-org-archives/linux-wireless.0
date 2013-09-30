Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:63306 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab3I3TGF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 15:06:05 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 0/3] ath10k: implement FW IE support
References: <20130927164636.2570.24076.stgit@localhost6.localdomain6>
Date: Mon, 30 Sep 2013 22:05:59 +0300
In-Reply-To: <20130927164636.2570.24076.stgit@localhost6.localdomain6> (Kalle
	Valo's message of "Fri, 27 Sep 2013 19:54:48 +0300")
Message-ID: <87vc1idt9k.fsf@kamboji.qca.qualcomm.com> (sfid-20130930_210615_583007_E428DA4A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> FW IE format is needed for ath10k automatically detect what features the
> firmware image supports. This is important especially with 10.x firmwares which
> has a different interface.
>
> Please review.
>
> v2:
>
> * added accidentally dropped board file loading (michal)
>
> * check that ATH10K_FW_IE_FW_IMAGE is available, fail otherwise
>
> v3:
>
> * resend with changes really listed in v2
>
> ---
>
> Kalle Valo (3):
>       ath10k: rename board_data in struct ath10k
>       ath10k: store separate pointers for firmware data
>       ath10k: implement firmware IE container support

All three applied.

-- 
Kalle Valo
