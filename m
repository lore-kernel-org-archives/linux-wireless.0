Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:58666 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbaJWNqw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 09:46:52 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/6] ath10k: pci related fixes 2014-10-09
References: <1413807282-27951-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 23 Oct 2014 16:46:45 +0300
In-Reply-To: <1413807282-27951-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 20 Oct 2014 14:14:36 +0200")
Message-ID: <87oat2q4oq.fsf@kamboji.qca.qualcomm.com> (sfid-20141023_154655_850530_DF11C432)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> First 2 patches address some irq issues.
>
> Other 4 fix and cleanup device resetting.
>
> Hopefully this will make ath10k a little more
> robust when it comes to warm reset.
>
> As a side effect of the changes ath10k now boots a
> little faster (slightly over a second instead of
> two).
>
> v2:
>  * don't remove power_up/down [Kalle]
>  * fix CE crash [Janusz]
>  * remove irq workaround in patch #2
>
>
> Michal Kazior (6):
>   ath10k: re-disable interrupts after target init
>   ath10k: mask/unmask msi fw irq
>   ath10k: split ce pipe init/alloc further

I have applied these patches.

>   ath10k: make warm reset a bit safer and faster
>   ath10k: split reset logic from power up
>   ath10k: don't reset chip on power_down

And dropped these patches per your request.

-- 
Kalle Valo
