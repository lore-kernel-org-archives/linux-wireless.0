Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:51497 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759AbYKFONB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 09:13:01 -0500
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: <linux-wireless@vger.kernel.org>,
	<rt2400-devel@lists.sourceforge.net>
Subject: PID control in Linux 2.6.27.4
Date: Thu, 6 Nov 2008 14:03:32 +0100
Message-ID: <9D4D31A146C744FE823A2BEF8490178F@gotws1589> (sfid-20081106_151308_511429_72A8BEC7)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, 

Running some initial evaluation test on Linux 2.6.27.4 from Linux git.

I have seen some strange behaviour on the rate control. 
Using an 11b AP works fine.
Using an 11b/g AP will not give high speed result. 
In fact it gives lower speed compared to the 11b AP

I'm using the rt61 minPCI as the WLAN HW.


I have the following linux config:
#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_RC_DEFAULT_PID=y
CONFIG_MAC80211_RC_DEFAULT="pid"
# CONFIG_MAC80211_MESH is not set
# CONFIG_MAC80211_LEDS is not set
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set


Are there any know issues with the PID function in this Linux version ?

/Lars

