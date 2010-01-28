Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51401.mail.re2.yahoo.com ([206.190.38.180]:40426 "HELO
	web51401.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751599Ab0A1PNb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2010 10:13:31 -0500
Message-ID: <774870.89795.qm@web51401.mail.re2.yahoo.com>
Date: Thu, 28 Jan 2010 07:13:30 -0800 (PST)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Significiant performance differences between ath5k and ath9k in 802.11a
To: linux-wireless@vger.kernel.org
Cc: ath5k-devel@lists.ath5k.org, ath9k-devel@lists.ath9k.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,
I have a strange performance problem with ath9k. I have two otherwise identical systems with an ath5k-supported card in system ATH5K and an ath9k supported card in system ATH9K.
Doing an UDP iperf run were ATH5K is the client/sender and ATH9K is the server/receiver I easily get data rates of 31MBit/s (tx data rate on the sender is manually set to 54 MBit/s).
Running the same test with ATH9K as client/sender and ATH5K as server/receiver gives maximum data rates of about 22MBit/s, about 30% less.

Doing the test against another ath9k system (e.g. ATH9K ==> ATH9K2) gives
the same max data rate of only 22 MBit/s, so the problem seems to be the
ath9k driver or the hardware. Can anybody confirm these problems? Is this
a known limitation? Any buttons to push to get things going faster?

Details:
the ath5k card is a AR2413 based design (Compex WLM54AG), the ath9k card
is a AR9220 (Compex WLM200NX 6A). The systems are connected in IBSS mode 
on channel 40 (5200MHz).
The kernel version is wireless-testing as of January, 26. The kernel is
slightly patched to enable IBSS in 802.11a (we are allowed to do this).

Can anybody shed some light on this strange issue? Luis?

-- 
Regards
       Joerg

__________________________________________________
Do You Yahoo!?
Sie sind Spam leid? Yahoo! Mail verfügt über einen herausragenden Schutz gegen Massenmails. 
http://mail.yahoo.com 
