Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:10880 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762985Ab3ECKsH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 May 2013 06:48:07 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath10k-devel@qca.qualcomm.com>
Subject: Re: ath10k: mac80211 driver for QCA9880
References: <87li8k0yu1.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 3 May 2013 13:48:01 +0300
In-Reply-To: <87li8k0yu1.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Mon, 15 Apr 2013 15:20:54 +0300")
Message-ID: <87bo8scpb2.fsf@kamboji.qca.qualcomm.com> (sfid-20130503_124813_184162_17C95F09)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> I just pushed initial version of ath10k, our new driver for QCA9880 &
> co, to github.com:
>
> https://github.com/kvalo/ath10k
>
> The driver is pretty small, roughly 14 kLOC. Even if the name implies
> that this is an evolution from ath9k, the drivers are actually very
> different. The biggest difference is that there's now firmware running
> on the chip.
>
> Once ath10k is ready I will send it for proper review. But we are not
> quite there yet.

I pushed the firmware temporarily here:

https://github.com/kvalo/ath10k-firmware

I also created a small page to the wiki:

http://wireless.kernel.org/en/users/Drivers/ath10k

But now anyone with QCA9880 or QCA9888 should be able to run ath10k now.
If someone does that we would be very interested about feedback.

-- 
Kalle Valo
