Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:47289 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172Ab0GaTA7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jul 2010 15:00:59 -0400
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: Pavel Roskin <proski@gnu.org>,
	"linville\@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath9k_htc: Add AP mode to supported modes
References: <19481.60102.659111.953695@gargle.gargle.HOWL>
	<1276878831.5110.4.camel@mj> <87pqy4dq10.fsf@purkki.adurom.net>
	<19540.27325.74223.869026@gargle.gargle.HOWL>
From: Kalle Valo <kvalo@adurom.com>
Date: Sat, 31 Jul 2010 22:00:56 +0300
In-Reply-To: <19540.27325.74223.869026@gargle.gargle.HOWL> (Sujith's message of "Sat\, 31 Jul 2010 23\:56\:05 +0530")
Message-ID: <877hkbeas7.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith <Sujith.Manoharan@atheros.com> writes:

> Kalle Valo wrote:
>> 
>> > I confirm that the AP mode is working on TP-Link TL-WN422G (0cf3:1006).
>> > I tested both patched of the series at once.
>> >
>> > That's great news!  TL-WN422G has an external antenna, connects over USB
>> > and supports AP mode.  Users keep asking about that combination of
>> > features.  Now we have an answer :-)
>> 
>> Cool, this would be really handy for testing wireless clients. Does it
>> also support proper multicast/broadcast buffering?
>
> Nope, the firmware lacks CAB queue support, which is required for PS
> buffering in Atheros' chipsets. Which is exactly why those patches
> were dropped. :(

I was just afraid of this. Oh well, AP support, USB and cheap sounded
like an impossible combination :/

Thank you for letting me know.

-- 
Kalle Valo
