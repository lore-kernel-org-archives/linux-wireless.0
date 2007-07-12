Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:50031
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbXGLJDH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2007 05:03:07 -0400
Message-Id: <20070712085432.528319000@bu3sch.de>
Date: Thu, 12 Jul 2007 10:54:32 +0200
From: mb@bu3sch.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: John Linville <linville@tuxdriver.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	linux-wireless@vger.kernel.org,
	Gary Zambrano <zambrano@broadcom.com>
Subject: [patch 0/2] Merge the SSB subsystem
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series merges the SSB subsystem and the SSB based USB OHCI HCD driver.
This is the first step to finally get bcm43xx-mac80211 merged, which is also
based on the SSB subsystem.

There's also a b44 port available, but it isn't ACKed by the b44 maintainers, yet.

--
Greetings Michael.

