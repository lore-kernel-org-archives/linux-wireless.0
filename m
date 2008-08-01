Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [116.90.133.99] ([116.90.133.99]:51563 "EHLO mars.unix.geek.nz"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbYHACyY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 22:54:24 -0400
Received: from [192.168.21.2] (ip-58-28-152-52.static-xdsl.xnet.co.nz [58.28.152.52])
	(Authenticated sender: jasper)
	by mars.unix.geek.nz (Postfix) with ESMTPSA id 452F3186FF2
	for <linux-wireless@vger.kernel.org>; Fri,  1 Aug 2008 14:48:07 +1200 (NZST)
Subject: 2.6.27-rc1-next-20080731 assoc problems
From: Jasper Bryant-Greene <jasper@amiton.co.nz>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Fri, 01 Aug 2008 14:48:15 +1200
Message-Id: <1217558895.3103.10.camel@luna.unix.geek.nz> (sfid-20080801_045427_652694_B19B078D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwl4965, Netgear WNR854T 802.11n AP

I seem to be getting these problems from time to time since moving from
2.6.26 to 2.6.27-rc1-next-20080731:

[  457.500308] wlan0: authenticate with AP 00:18:4d:XX:XX:XX
[  457.506530] wlan0: authenticate with AP 00:18:4d:XX:XX:XX
[  457.508347] wlan0: authenticated
[  457.508359] wlan0: associate with AP 00:18:4d:XX:XX:XX
[  457.511967] wlan0: RX AssocResp from 00:18:4d:XX:XX:XX (capab=0x411
status=1 aid=0)
[  457.511978] wlan0: AP denied association (code=1)
[  457.704131] wlan0: associate with AP 00:18:4d:XX:XX:XX
[  457.708870] wlan0: RX AssocResp from 00:18:4d:XX:XX:XX (capab=0x411
status=1 aid=0)
[  457.708877] wlan0: AP denied association (code=1)
[  457.903773] wlan0: associate with AP 00:18:4d:XX:XX:XX
[  457.906330] wlan0: RX AssocResp from 00:18:4d:XX:XX:XX (capab=0x411
status=1 aid=0)
[  457.906333] wlan0: AP denied association (code=1)
[  458.105105] wlan0: association with AP 00:18:4d:XX:XX:XX timed out

Is it really my AP, as the messages suggest?

-jasper

