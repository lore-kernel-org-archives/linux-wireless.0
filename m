Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:45092 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143AbYHOWaY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2008 18:30:24 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [PATCH RFT] b43: Rewrite PHY API for N-PHY/LP-PHY
Date: Sat, 16 Aug 2008 00:29:56 +0200
MIME-Version: 1.0
Message-Id: <200808160029.56876.mb@bu3sch.de> (sfid-20080816_003028_012874_6F812853)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the first part for the rewrite of the b43 PHY API.
This is needed in order to make development of N and LP code possible.

PLEASE TEST TEST TEST TEST TEST

Lots of testing on lots of different devices is needed to ensure this
doesn't introduce regressions due to typos.
95% of the patch just moves large parts of the PHY code from one file
to another. More move-patches will follow.
5% of the patch introduces an "ops" based PHY API.

Please test on all of your devices.

http://bu3sch.de/patches/wireless-testing/20080816-0023/patches/002-b43-phy-ops.patch
Apply against wireless-testing.git

(Not attached to the mail, as it is really big)
