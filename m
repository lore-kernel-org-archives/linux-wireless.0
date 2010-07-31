Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13805 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753714Ab0GaSWd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jul 2010 14:22:33 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 31 Jul 2010 11:22:33 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19540.27325.74223.869026@gargle.gargle.HOWL>
Date: Sat, 31 Jul 2010 23:56:05 +0530
To: Kalle Valo <kvalo@adurom.com>
CC: Pavel Roskin <proski@gnu.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath9k_htc: Add AP mode to supported modes
In-Reply-To: <87pqy4dq10.fsf@purkki.adurom.net>
References: <19481.60102.659111.953695@gargle.gargle.HOWL>
	<1276878831.5110.4.camel@mj>
	<87pqy4dq10.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> Sorry for a late reply, I'm really backlogged :)
> 
> > I confirm that the AP mode is working on TP-Link TL-WN422G (0cf3:1006).
> > I tested both patched of the series at once.
> >
> > That's great news!  TL-WN422G has an external antenna, connects over USB
> > and supports AP mode.  Users keep asking about that combination of
> > features.  Now we have an answer :-)
> 
> Cool, this would be really handy for testing wireless clients. Does it
> also support proper multicast/broadcast buffering?

Nope, the firmware lacks CAB queue support, which is required for PS buffering
in Atheros' chipsets. Which is exactly why those patches were dropped. :(

Sujith
