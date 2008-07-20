Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:44122 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079AbYGTCnr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 22:43:47 -0400
Date: Sat, 19 Jul 2008 22:43:41 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 0/4] Atheros IEEE 802.11n ath9k driver
Message-ID: <20080720024341.GQ17936@ruslug.rutgers.edu> (sfid-20080720_044359_648096_BFA4A85A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patches adds the ath9k driver, which adds support
for all Atheors IEEE 802.11n chipsets along some new linked list
helpers. We are hosting this driver temporarily in a git tree until
it is merged into wireless-testing.

More information about this driver is available at:

http://wireless.kernel.org/en/users/Drivers/ath9k

Our mailing list for this driver is:

https://lists.ath9k.org/mailman/listinfo/ath9k-devel

The temporary git URL to build this driver separately is:

git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/ath9k.git

If you would like to wget these patches individually you can
get them here:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/

We realize there is a lot of work ahead and look forward to
any comments on the driver. As it stands this has been mainly tested
only on STA mode. We have a few known issues but are working hard
on resolving them.

We are eager to talk to others about this driver further at the
Wireless summit.

Note: kernel.org is rsyncing right now, so in the meantime you can
fetch the patches and source from the git tree from:

git://w1.fi/srv/git/ath9k.git

http://w1.fi/ath9k/

  Luis
