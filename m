Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19645 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaKZGiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 01:38:16 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] ath10k: Fix shared WEP
References: <1416896220-29691-1-git-send-email-sujith@msujith.org>
Date: Wed, 26 Nov 2014 08:38:10 +0200
In-Reply-To: <1416896220-29691-1-git-send-email-sujith@msujith.org> (Sujith
	Manoharan's message of "Tue, 25 Nov 2014 11:46:58 +0530")
Message-ID: <87lhmyxy99.fsf@kamboji.qca.qualcomm.com> (sfid-20141126_073819_340982_F760E00F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> When static keys are used in shared WEP, when a
> station is associated, message 3 is sent with an
> encrypted payload. But, for subsequent
> authentications that are triggered without a
> deauth, the auth frame is decrypted by the HW.
>
> To handle this, check if the WEP keys have already
> been set for the peer and if so, mark the
> frame as decrypted. This scenario can happen
> when a station changes its default TX key and initiates
> a new authentication sequence.
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Thanks, all three applied.

-- 
Kalle Valo
