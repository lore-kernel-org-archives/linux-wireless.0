Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.irobot.com ([206.83.81.187]:48368 "EHLO smtp1.irobot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab0BARu6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2010 12:50:58 -0500
Message-ID: <4B67147E.6080800@irobot.com>
Date: Mon, 01 Feb 2010 09:50:54 -0800
From: Adam Wozniak <awozniak@irobot.com>
MIME-Version: 1.0
To: Joerg Pommnitz <pommnitz@yahoo.com>
CC: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: Significiant performance differences between ath5k and ath9k
 in 802.11a
References: <774870.89795.qm@web51401.mail.re2.yahoo.com>
In-Reply-To: <774870.89795.qm@web51401.mail.re2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Your numbers for ath9k in the 5GHz band jibe with what I've observed for 
the ar9170 in ad-hoc mode.
If you go down to 2.4GHz you'll see about 16MBit/s.

I have no other numbers to offer for comparison.

--Adam

Joerg Pommnitz wrote:
> Hello all,
> I have a strange performance problem with ath9k. I have two otherwise identical systems with an ath5k-supported card in system ATH5K and an ath9k supported card in system ATH9K.
> Doing an UDP iperf run were ATH5K is the client/sender and ATH9K is the server/receiver I easily get data rates of 31MBit/s (tx data rate on the sender is manually set to 54 MBit/s).
> Running the same test with ATH9K as client/sender and ATH5K as server/receiver gives maximum data rates of about 22MBit/s, about 30% less.
>
> Doing the test against another ath9k system (e.g. ATH9K ==> ATH9K2) gives
> the same max data rate of only 22 MBit/s, so the problem seems to be the
> ath9k driver or the hardware. Can anybody confirm these problems? Is this
> a known limitation? Any buttons to push to get things going faster?
>
> Details:
> the ath5k card is a AR2413 based design (Compex WLM54AG), the ath9k card
> is a AR9220 (Compex WLM200NX 6A). The systems are connected in IBSS mode 
> on channel 40 (5200MHz).
> The kernel version is wireless-testing as of January, 26. The kernel is
> slightly patched to enable IBSS in 802.11a (we are allowed to do this).
>
> Can anybody shed some light on this strange issue? Luis?
>
>   

