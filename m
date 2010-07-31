Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:53856 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978Ab0GaIln (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jul 2010 04:41:43 -0400
To: Pavel Roskin <proski@gnu.org>
Cc: Sujith <Sujith.Manoharan@atheros.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] ath9k_htc: Add AP mode to supported modes
References: <19481.60102.659111.953695@gargle.gargle.HOWL>
	<1276878831.5110.4.camel@mj>
From: Kalle Valo <kvalo@adurom.com>
Date: Sat, 31 Jul 2010 11:16:59 +0300
In-Reply-To: <1276878831.5110.4.camel@mj> (Pavel Roskin's message of "Fri\, 18 Jun 2010 12\:33\:51 -0400")
Message-ID: <87pqy4dq10.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry for a late reply, I'm really backlogged :)

> I confirm that the AP mode is working on TP-Link TL-WN422G (0cf3:1006).
> I tested both patched of the series at once.
>
> That's great news!  TL-WN422G has an external antenna, connects over USB
> and supports AP mode.  Users keep asking about that combination of
> features.  Now we have an answer :-)

Cool, this would be really handy for testing wireless clients. Does it
also support proper multicast/broadcast buffering?

-- 
Kalle Valo
