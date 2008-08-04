Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:59380 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717AbYHDHaM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 03:30:12 -0400
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 04 Aug 2008 00:30:12 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Christoph Hellwig <hch@lst.de>,
	Jack Howarth <howarth@bromo.msbb.uc.edu>,
	Jouni Malinen <jouni.malinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Pavel Roskin <proski@gnu.org>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 4/4] ath9k: Add new Atheros IEEE 802.11n driver [reference to URL]
Date: Mon, 4 Aug 2008 00:30:07 -0700
Message-ID: <1217835007-15173-1-git-send-email-lrodriguez@atheros.com> (sfid-20080804_093022_372695_B212066D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds the new mac80211 11n ath9k Atheros driver. Only STA support
is currently enabled and tested.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jack Howarth <howarth@bromo.msbb.uc.edu>
Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>

This patch is about 1MB so you can download it from:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/add-ath9k-02/0004-ath9k-Add-new-Atheros-IEEE-802.11n-driver.patch

  Luis
