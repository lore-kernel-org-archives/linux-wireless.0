Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bromo.msbb.uc.edu ([129.137.3.146]:41485 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751948AbYHHOQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2008 10:16:17 -0400
Received: from bromo.msbb.uc.edu (localhost.localdomain [127.0.0.1])
	by bromo.msbb.uc.edu (Postfix) with ESMTP id 92059B0060
	for <linux-wireless@vger.kernel.org>; Fri,  8 Aug 2008 10:16:16 -0400 (EDT)
Received: (from howarth@localhost)
	by bromo.msbb.uc.edu (8.14.2/8.14.2/Submit) id m78EGGA4026291
	for linux-wireless@vger.kernel.org; Fri, 8 Aug 2008 10:16:16 -0400
Date: Fri, 8 Aug 2008 10:16:16 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: linux-wireless@vger.kernel.org
Subject: N protocol on 802.11a freq signal strength
Message-ID: <20080808141616.GA26224@bromo.msbb.uc.edu> (sfid-20080808_161622_370556_E650FEF3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

    After replacing my Linksys WRT150N wireless router with an
Apple Airport Extreme Gigabit ethernet wireless router, configured
for using the N protocols on the 802.11a wireless frequencies, I
can confirm that the ath9k git from last week connects to this
configuration. I have noticed one oddity though. The reported
signal strength (in the NetworkManager menu bar icon) is significantly
lower than that shown under Mac OS X 10.5. Also, I notice under Mac OS X
10.5, by holding the option key on the Finder's Airport icon, that the
transmit speed is 300 Mbps when the MacBook Pro is in the same room as
the wireless router but only 108 Mbps when a couple rooms away. Should
the ath9k report such dynamic changes in transmit speed? Under Mac OS X
that transmit speed changes as I move the portable back and forth
between the two locations. Thanks in advance for any information.
                       Jack
ps I am also using wide channels if it makes any difference.
