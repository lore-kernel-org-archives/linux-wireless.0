Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout1-sn1.fre.skanova.net ([81.228.11.98]:61169 "EHLO
	pne-smtpout1-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754896AbYBYS4l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 13:56:41 -0500
Received: from gotws1589 (81.237.220.22) by pne-smtpout1-sn1.fre.skanova.net (7.3.129)
        id 47A979500066F2AE for linux-wireless@vger.kernel.org; Mon, 25 Feb 2008 19:56:40 +0100
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: <linux-wireless@vger.kernel.org>
Subject: mac80211: Roaming issues.
Date: Mon, 25 Feb 2008 19:56:50 +0100
Message-ID: <005101c877e0$2ded1170$0b3ca8c0@gotws1589> (sfid-20080225_185644_237646_16C3B889)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have been working with Ivo for a while, testing/debugging the rt2x00
driver.

Parallel with that I have been testing the roaming performance in different
environments/sites.
I have discovered a number of improvement to the mac80211 driver that will
significantly speed up the roaming function. The actual roaming is of course
controlled form the wpa_supplicant, but with my patches, the
mac80211/wpa_supplicant will cooperate much smother and faster.

My question are:
- Is this the place to discuss the mac80211 driver ?
- How is 'responsible' for the mac80211 driver ?

Regards
Lars



