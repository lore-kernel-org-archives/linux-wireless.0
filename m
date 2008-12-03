Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16605 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbYLCCVI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 21:21:08 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 18:21:08 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <Sujith.Manoharan@atheros.com>, <senthilkumar@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 0/2] ath9k: few memory fixes
Date: Tue, 2 Dec 2008 18:21:04 -0800
Message-ID: <1228270866-21516-1-git-send-email-lrodriguez@atheros.com> (sfid-20081203_032113_104029_53F6F94B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series addresses some memory issues present on ath9k
regarding allocation and not handling failed DMA maps. These
two patches replace the patch titled:

[PATCH] ath9k: Use GFP_ATOMIC when allocating private area

But also adds the failed DMA checks.

I've merged the ath_tx_setup_buffer() failure case into the DMA checks.

  Luis
