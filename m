Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56818 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbbKLTEI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 14:04:08 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] update ath10k support for QCA9377 chips
References: <1446713443-22542-1-git-send-email-bartosz.markowski@tieto.com>
Date: Thu, 12 Nov 2015 21:03:51 +0200
In-Reply-To: <1446713443-22542-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Thu, 5 Nov 2015 09:50:39 +0100")
Message-ID: <874mgr6nvs.fsf@kamboji.qca.qualcomm.com> (sfid-20151112_200412_388008_FFCC3DC9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> * Clarifying the naming scheme for QCA9377 targets
> * Adding the dev_id mathod (RFC) as a HW identification helper
> * updating missing hw_params for 1.1 target
>
> ---
>
> Notes:
>   v2:
>    * rebase
>    * fix the whitespace mess in patch 4/4 [Kalle]
>
> Bartosz Markowski (4):
>   ath10k: fix the currently supported QCA9377 target version name
>   ath10k: update missing hw_params of QCA9377 hw1.1
>   ath10k: introduce dev_id to hw_params
>   ath10k: add QCA9377 hw1.0 support

Applied to ath-current, thanks.

-- 
Kalle Valo
