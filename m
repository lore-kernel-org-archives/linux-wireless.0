Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rain.florz.de ([62.216.164.86]:50768 "EHLO
	rain.florz.dyndns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750768AbZLRSll (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 13:41:41 -0500
Date: Fri, 18 Dec 2009 19:02:05 +0100
From: Florian Zumbiehl <florz@florz.de>
To: flamingice@sourmilk.net, andreamrl@tiscali.it,
	herton@mandriva.com.br, htl10@users.sourceforge.net,
	Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Power consumption of RTL8187 (driver)/recommendations for
	low-power USB 802.11 adapter?
Message-ID: <20091218180205.GD2512@florz.florz.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm not really sure whom to write to, so ... I'm writing to all of you, for
now ;-)

I just bought a USB wireless stick with an RTL8187B inside. The idea was to
use it with my laptop. In principle, it works just fine ... if it didn't
cause the computer to triple its idle power consumption from some
7.5 to ~ 22.5 Watts.

I don't have a clue (yet) where exactly all that power goes to, and how
much of it is actually being used by the stick itself (it's getting pretty
warm, too - maybe you have a clue what to expect there?). But apparently,
quite a bit of that increased power consumption is due to the CPU entering
ACPI sleep states for a much smaller proportion of time, and not entering
the highest sleep state at all anymore (which otherwise makes up around
98 % of the time) due to some polling/high-frequency interrupt of the
driver. After all, even the most inefficient voltage regulator can't
make 15 W from USB's max. 2.5 W (I hope ...).

Now, the obvious question is: Is there anything one could do about that?

And if not, or possibly even if: Any recommendation for a power-efficient
USB 802.11 adapter - in particular something that does not cause
CPU wakeups all the time when there is no actual network traffic?

Florian
