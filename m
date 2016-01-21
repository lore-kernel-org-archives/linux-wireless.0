Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54668 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759071AbcAUNLs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 08:11:48 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net, j@w1.fi
Subject: Re: [PATCH v2 2/2] ath9k: use min rate when MCC and nullfunc
References: <1451990134-15183-1-git-send-email-janusz.dziedzic@tieto.com>
	<1451990134-15183-2-git-send-email-janusz.dziedzic@tieto.com>
Date: Thu, 21 Jan 2016 15:11:41 +0200
In-Reply-To: <1451990134-15183-2-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Tue, 5 Jan 2016 11:35:34 +0100")
Message-ID: <87powvyt4i.fsf@kamboji.qca.qualcomm.com> (sfid-20160121_141151_978164_3A7BF6FC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> In case of nullfunc and MCC case use lowest
> possible rates.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

So what should I do with this patch? The mac80211 patch from this series
was dropped, should I do the same?

https://patchwork.kernel.org/patch/7953631/

Also please try to keep driver and mac80211 patches separate, that's
easier for me and Johannes.

-- 
Kalle Valo
