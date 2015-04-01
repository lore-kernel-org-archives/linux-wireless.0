Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:2991 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbbDARed (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 13:34:33 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] ath10k: improve set_bitrate_mask
References: <1427798961-7334-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 1 Apr 2015 20:34:20 +0300
In-Reply-To: <1427798961-7334-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 31 Mar 2015 10:49:19 +0000")
Message-ID: <874mozycpv.fsf@kamboji.qca.qualcomm.com> (sfid-20150401_193436_889087_49D6C519)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This makes set_bitrate_mask more flexible by
> allowing more than applying simple single rate or
> max nss limits.
>
> This still isn't ideal and VHT MCSs can't be set
> separately (only a few range-options are allowed).
>
> v2:
>  * fix ouf-of-bounds
>  * rebased to master branch + multi-channel patches
>
> This will not apply cleanly without multi-channel
> support and conflict resolution will be
> non-trivial.
>
>
> Michal Kazior (2):
>   ath10k: clean up set_bitrate_mask handling

Thanks, this patch applied.

>   ath10k: implement more versatile set_bitrate_mask

This patch dropped as requested.

-- 
Kalle Valo
