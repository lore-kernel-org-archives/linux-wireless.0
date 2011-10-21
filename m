Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay1.uni-rostock.de ([139.30.8.201]:3414 "EHLO
	mailrelay1.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab1JUOim (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 10:38:42 -0400
Message-ID: <4EA182A8.2060801@uni-rostock.de> (sfid-20111021_163846_295719_0902A8C0)
Date: Fri, 21 Oct 2011 16:33:12 +0200
From: Till Wollenberg <till.wollenberg@uni-rostock.de>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
Subject: Obtaining channel measurements from current chipsets
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

I'm very interested in obtaining channel measurements from current
802.11a/g/n chipsets. I know that there are indicators for signal
strength, noise floor, RSSI etc., but I'd like to get more fine-grained
measurements such as magnitude/phase of the OFDM sub-carriers.

Such information is also needed for the (optional) 802.11n "channel
state information" feature, so I suppose that the vendors include
support for it in their chipsets.

Can someone give me a hint where to look at? So far I found that
other people are interested as well [1], but I did not find any
hints in the source code of the wireless drivers or any public
available spec. [2] shows how it could look like, but unfortunately
it depends mainly on modifications to the binary-only NIC firmware.

Best Regards
Till

[1] http://www.mail-archive.com/ath9k-devel@lists.ath9k.org/msg03875.html
[2] http://dhalperi.github.com/linux-80211n-csitool/
