Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54859 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbcGaJTr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jul 2016 05:19:47 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: russianneuromancer@ya.ru
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: Dell Venue 8 Pro "Dell Wireless" (Atheros 6k) chipset with SDIO ID 0271:0418 not recognized/supported
References: <14140188.nOOhQX7Q2z@laptop1>
Date: Sun, 31 Jul 2016 12:19:43 +0300
In-Reply-To: <14140188.nOOhQX7Q2z@laptop1> (russianneuromancer@ya.ru's message
	of "Fri, 29 Jul 2016 23:19:10 +0800")
Message-ID: <87bn1e88r4.fsf@purkki.adurom.net> (sfid-20160731_111958_248469_F21A47C2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

russianneuromancer@ya.ru writes:

> Please look into commentary 50 from bugreport https://bugzilla.kernel.org/show_bug.cgi?id=67921#c50 
> There is patch for enabling support of Atheros Wireless adapter in Dell Venue 8 Pro tablet.
>  
> Please review if this possible to include this patch into upstream.

Do you mean this ath6kl patch:

https://github.com/AdamWill/baytrail-m/blob/master/kernel/support-Dell-OEM-chipset-found-in-Venue-8-Pro-SDIO-I.patch

That looks good to me, but please submit it officially as defined in the wiki:

https://wireless.wiki.kernel.org/en/users/drivers/ath6kl#hacking_on_ath6kl

I also saw the comment about broken ath.git link, I fixed that now.

-- 
Kalle Valo
