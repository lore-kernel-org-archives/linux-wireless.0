Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60713 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932794AbcDYRzH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2016 13:55:07 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Vittorio Gambaletta \(VittGam\)" <linux-wireless@vittgam.net>
Cc: <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
	<ath9k-devel@venema.h4ckr.net>
Subject: Re: [PATCH 1/2] ath9k: Add a module parameter to invert LED polarity.
References: <ath9k-patch-20160411-1@vittgam.net>
Date: Mon, 25 Apr 2016 20:55:00 +0300
In-Reply-To: <ath9k-patch-20160411-1@vittgam.net> (Vittorio Gambaletta's
	message of "Mon, 11 Apr 2016 04:48:54 +0200")
Message-ID: <87shy91sln.fsf@kamboji.qca.qualcomm.com> (sfid-20160425_195512_159135_EB1AAEE2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Vittorio Gambaletta (VittGam)" <linux-wireless@vittgam.net> writes:

> The LED can be active high instead of active low on some hardware.
>
> Add the led_active_high module parameter. It defaults to -1 to obey
> platform data as before.
>
> Setting the parameter to 1 or 0 will force the LED respectively
> active high or active low.
>
> Cc: <linux-wireless@vger.kernel.org>
> Cc: <ath9k-devel@qca.qualcomm.com>
> Cc: <ath9k-devel@lists.ath9k.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Vittorio Gambaletta <linuxbugs@vittgam.net>

Both patches applied, thanks.

-- 
Kalle Valo
