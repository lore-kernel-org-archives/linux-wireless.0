Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:62747 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225AbYHQGqi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Aug 2008 02:46:38 -0400
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: <rt2400-devel@lists.sourceforge.net>,
	<linux-wireless@vger.kernel.org>
Subject: mac80211 / rt2x00 / rt61 and adhoc status
Date: Sun, 17 Aug 2008 07:36:52 +0200
Message-ID: <057f01c9002b$413b0330$0b3ca8c0@gotws1589> (sfid-20080817_084642_968472_1E9D69D6)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

What is the expected status of the adhoc function ?

Have tried using the wpa_supplicant and got the -EBUSY from
ieee80211_ioctl_siwmode().
Worked around that and got the rt61 to join an existing adhoc net, but no
data flow.

Two tests cases, but same behaviour:
1) Linx.git: 2.6.26 and wpa_supplicant 0.5.9
2) rt2x00.git: Version 2.2.0 and wpa_supplicant 0.5.9

/Lars

