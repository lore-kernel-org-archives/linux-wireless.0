Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:47533 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766701AbXDSNoO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2007 09:44:14 -0400
Message-ID: <462772BB.1010900@lwfinger.net>
Date: Thu, 19 Apr 2007 08:46:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Broadcom Linux <bcm43xx-dev@lists.berlios.de>
CC: bcm43xx devel <Bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/3] bcm43xx-mac80211: Fix machine check on PPC for phy->rev  == 1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For BCM4306 chips with phy->rev == 1, several factors in the code lead to machine checks. These are 
fixed by several kinds of changes. The remaining patches in this series will separate these into 
correcting typos and problems with the program logic, updates to the specs, and some necessary 
modifications that are not found in the specs. The latter fixes have previously been required for 
bcm43xx-softmac, and are clearly noted by comments.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

