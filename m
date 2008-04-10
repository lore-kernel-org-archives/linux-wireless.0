Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:26891 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbYDJLdS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2008 07:33:18 -0400
Received: from poczta.interia.pl (mi02.poczta.interia.pl [10.217.12.2])
	by smtp239.poczta.interia.pl (INTERIA.PL) with ESMTP id E5CF1D47A3
	for <linux-wireless@vger.kernel.org>; Thu, 10 Apr 2008 13:33:13 +0200 (CEST)
Received: from [192.168.1.27] (d90-129-71-151.cust.tele2.pl [90.129.71.151])
	by poczta.interia.pl (INTERIA.PL) with ESMTP id E7B2B2BF89E
	for <linux-wireless@vger.kernel.org>; Thu, 10 Apr 2008 13:33:12 +0200 (CEST)
Message-ID: <47FDFB57.3010700@interia.pl> (sfid-20080410_123330_038534_DED0CD6A)
Date: Thu, 10 Apr 2008 13:34:47 +0200
From: Maciek Kaliszewski <mkalkal@interia.pl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Kismet shows no clients (drivers iwl3945.ko or p54pci.ko)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have "02:00.0 Network controller: Intersil Corporation ISL3890 [Prism
GT/Prism Duette]/ISL3886 [Prism Javelin/Prism Xbow] (rev 01)"
which does not work with prism54.ko driver . So I have to use p54pci.ko
(from kernel 2.6.25-rc8) .
When I run kismet ,it detects wifi networks , but shows there is no
clients on the networks (I started data transfer on that network but it
didn't help)
Tcpdump on wlan0 interface (Monitor mode ) shows :

tcpdump: WARNING: wlan0: no IPv4 address assigned
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on wlan0, link-type IEEE802_11_RADIO (802.11 plus BSD radio
information header), capture size 96 bytes
12:38:51.010818 490951797us tsft 1.0 Mb/s 2457 MHz (0x0480) 81dB signal
[0x0000000e] Beacon (APTEKA) [1.0* 2.0* 5.5* 11.0* 18.0 24.0* 36.0 54.0
Mbit] ESS CH: 11, PRIVACY
12:38:51.317951 491258998us tsft 1.0 Mb/s 2457 MHz (0x0480) 83dB signal
[0x0000000e] Beacon (APTEKA) [1.0* 2.0* 5.5* 11.0* 18.0 24.0* 36.0 54.0
Mbit] ESS CH: 11, PRIVACY
12:38:51.625134 491566198us tsft 1.0 Mb/s 2457 MHz (0x0480) 79dB signal
[0x0000000e] Beacon (APTEKA) [1.0* 2.0* 5.5* 11.0* 18.0 24.0* 36.0 54.0
Mbit] ESS CH: 11, PRIVACY
12:38:51.932369 491873444us tsft 1.0 Mb/s 2457 MHz (0x0480) 79dB signal
[0x0000000e] Beacon (APTEKA) [1.0* 2.0* 5.5* 11.0* 18.0 24.0* 36.0 54.0
Mbit] ESS CH: 11, PRIVACY
12:38:52.034714 491975793us tsft 1.0 Mb/s 2457 MHz (0x0480) 83dB signal
[0x0000000e] Beacon (APTEKA) [1.0* 2.0* 5.5* 11.0* 18.0 24.0* 36.0 54.0
Mbit] ESS CH: 11, PRIVACY
12:38:52.137106 492078194us tsft 1.0 Mb/s 2457 MHz (0x0480) 88dB signal
[0x0000000e] Beacon (APTEKA) [1.0* 2.0* 5.5* 11.0* 18.0 24.0* 36.0 54.0
Mbit] ESS CH: 11, PRIVACY
12:38:52.239481 492180591us tsft 1.0 Mb/s 2457 MHz (0x0480) 74dB signal
[0x0000000e] Beacon (APTEKA) [1.0* 2.0* 5.5* 11.0* 18.0 24.0* 36.0 54.0
Mbit] ESS CH: 11, PRIVACY
12:38:52.341902 492282991us tsft 1.0 Mb/s 2457 MHz (0x0480) 84dB signal
[0x0000000e] Beacon (APTEKA) [1.0* 2.0* 5.5* 11.0* 18.0 24.0* 36.0 54.0
Mbit] ESS CH: 11, PRIVACY
12:38:52.444271 492385391us tsft 1.0 Mb/s 2457 MHz (0x0480) 80dB signal
[0x0000000e] Beacon (APTEKA) [1.0* 2.0* 5.5* 11.0* 18.0 24.0* 36.0 54.0
Mbit] ESS CH: 11, PRIVACY
12:38:52.649064 492590193us tsft 1.0 Mb/s 2457 MHz (0x0480) 82dB signal
[0x0000000e] Beacon (APTEKA) [1.0* 2.0* 5.5* 11.0* 18.0 24.0* 36.0 54.0
Mbit] ESS CH: 11, PRIVACY
12:38:52.751479 492692596us tsft 1.0 Mb/s 2457 MHz (0x0480) 81dB signal
[0x0000000e] Beacon (APTEKA) [1.0* 2.0* 5.5* 11.0* 18.0 24.0* 36.0 54.0
Mbit] ESS CH: 11, PRIVACY
12:38:52.853861 492794991us tsft 1.0 Mb/s 2457 MHz (0x0480) 68dB signal
[0x0000000e] Beacon (APTEKA) [1.0* 2.0* 5.5* 11.0* 18.0 24.0* 36.0 54.0
Mbit] ESS CH: 11, PRIVACY
12:38:52.956271 492897395us tsft 1.0 Mb/s 2457 MHz (0x0480) 68dB signal
[0x0000000e] Beacon (APTEKA) [1.0* 2.0* 5.5* 11.0* 18.0 24.0* 36.0 54.0
Mbit] ESS CH: 11, PRIVACY
12:38:53.161056 493102186us tsft 1.0 Mb/s 2457 MHz (0x0480) 88dB signal
[0x0000000e] Beacon (APTEKA) [1.0* 2.0* 5.5* 11.0* 18.0 24.0* 36.0 54.0
Mbit] ESS CH: 11, PRIVACY
12:38:53.263467 493204593us tsft 1.0 Mb/s 2457 MHz (0x0480) 87dB signal
[0x0000000e] Beacon (APTEKA) [1.0* 2.0* 5.5* 11.0* 18.0 24.0* 36.0 54.0
Mbit] ESS CH: 11, PRIVACY
12:38:53.365850 493306992us tsft 1.0 Mb/s 2457 MHz (0x0480) 86dB signal
[0x0000000e] Beacon (APTEKA) [1.0* 2.0* 5.5* 11.0* 18.0 24.0* 36.0 54.0
Mbit] ESS CH: 11, PRIVACY
12:38:53.468229 493409393us tsft 1.0 Mb/s 2457 MHz (0x0480) 78dB signal
[0x0000000e] Beacon (APTEKA) [1.0* 2.0* 5.5* 11.0* 18.0 24.0* 36.0 54.0
Mbit] ESS CH: 11, PRIVACY




As far as I can read the log , it show there is no traffic on net
APTEKA, but I know there is a data transfer on the net.
I had similar results on other computer ,intel wifi card with iwl3945.ko
driver(kernel 2.6.24.2).

Regards
Maciek






----------------------------------------------------------------------
Sprawdz, czy jestes prawdziwym internauta!
Kliknij http://link.interia.pl/f1d6e

