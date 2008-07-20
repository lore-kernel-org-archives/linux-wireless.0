Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:47687 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236AbYGTCpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 22:45:07 -0400
Date: Sat, 19 Jul 2008 22:45:00 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 1/4] Add new Atheros IEEE 802.11n ath9k driver
Message-ID: <20080720024500.GR17936@ruslug.rutgers.edu> (sfid-20080720_044515_228476_FA83BA3F)
References: <20080720024341.GQ17936@ruslug.rutgers.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080720024341.GQ17936@ruslug.rutgers.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds the new mac80211 ath9k Atheros driver. Only STA support is
currently enabled and tested. This patch is close to 1 MB so please
download from:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/add-ath9k-01/0001-Add-new-Atheros-IEEE-802.11n-ath9k-driver.patch

Note: for now kernel.org is rsyncing so until this is done you can get this from:

http://w1.fi/ath9k/0001-Add-new-Atheros-IEEE-802.11n-ath9k-driver.patch

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
