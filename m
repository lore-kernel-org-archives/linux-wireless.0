Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33266 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab0BSRC6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 12:02:58 -0500
Subject: Re: [PATCH 01/11] b43: N-PHY: add some registers and structs
 definitions
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4B7EBF0A.1060907@lwfinger.net>
References: <1265745883-3392-2-git-send-email-zajec5@gmail.com>
	 <1266591292.15178.1.camel@jlt3.sipsolutions.net>
	 <4B7EB31D.2000603@lwfinger.net>
	 <1266596602.15178.2.camel@jlt3.sipsolutions.net>
	 <4B7EBF0A.1060907@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Feb 2010 18:02:54 +0100
Message-ID: <1266598974.3754.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-02-19 at 10:40 -0600, Larry Finger wrote:

> Rafał is taking exams now, but said in one of our last communications
> that he
> was finishing up some radio code. After that, he expected some signs
> of life.

Neat.

> What PHY revision do you have? Between 2 and 3 there were a lot of
> changes
> including a new radio version. Rafał has a 2, thus he has been
> concentrating on
> that one.
> 
> Do you have any log messages on the SSB adjustments?

[    5.861375] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x17, vendor 0x4243)
[    5.861390] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x10, vendor 0x4243)
[    5.861402] ssb: Core 2 found: PCI-E (cc 0x820, rev 0x0B, vendor 0x4243)
[    5.861414] ssb: Core 3 found: PCI (cc 0x804, rev 0x0E, vendor 0x4243)
[    5.861427] ssb: Core 4 found: USB 2.0 Device (cc 0x81A, rev 0x05, vendor 0x4243)
[    5.861439] ssb: Core 5 found: UNKNOWN (cc 0x8FF, rev 0x00, vendor 0x4243)
[    5.861452] ssb: Core 6 found: Internal Memory (cc 0x80E, rev 0x03, vendor 0x4243)
[    5.900494] ssb: Found rev 2 PMU (capabilities 0x04583002)
[    5.900500] ssb: ERROR: PLL init unknown for device 4322
[    5.900844] ssb: ERROR: PMU resource config unknown for device 4322
[    5.909764] ssb: SPROM revision 8 detected.
...
[    6.378717] b43-phy0: Broadcom 4322 WLAN found (core revision 16)
[    6.482611] b43-phy0 debug: Found PHY: Analog 8, Type 4, Revision 4
[    6.482638] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2056, Revision 3



johannes

