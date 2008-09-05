Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:63598 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750810AbYIEXCm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2008 19:02:42 -0400
Message-ID: <48C1BA91.7050106@lwfinger.net> (sfid-20080906_010254_400378_C9D2737A)
Date: Fri, 05 Sep 2008 18:02:41 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Broadcom Wireless <bcm43xx-dev@berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Speed enhancement for BCM4306/2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I recently found some places where the G-PHY initialization 
specifications were wrong. I updated the relevant parts of the V3 
specifications at http://bcm-specs.sipsolutions.net - the pages for 
GPHY, B6PHY and B5PHY were changed.

When I prepared a patch containing these changes, the speed of the 
BCM4306/2 for OFDM rates more than doubled. As an example, when 
iwconfig is used to set the rate at 36M, the TX rate increased from 
6.8 to 15.8 Mb/s.

Unfortunately, direct submission of my patch would violate the 
clean-room rules. Michael Buesch has other things that are more 
important. As a result, we need someone to look at the changes on the 
web page and prepare a patch for submission. I will be happy to test 
your submission.

Larry
