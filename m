Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34240 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbcFWPNh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 11:13:37 -0400
Received: by mail-wm0-f65.google.com with SMTP id 187so11789976wmz.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2016 08:13:36 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Cc: nbd@nbd.name
Subject: [RFC] ath9k: add devicetree support to ath9k
Date: Thu, 23 Jun 2016 17:13:26 +0200
Message-Id: <20160623151328.24061-1-martin.blumenstingl@googlemail.com> (sfid-20160623_171340_926324_9CDFD56E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds support for configuring ath9k based devices via
devicetree. This was tested on PCI(e) based devices. This should work
for AHB based devices as well as soon as the ath79 platform is ready
to populate the ath9k wmac via devicetree.

This series depends on my previous series:
"ath9k: extend and improve handling of ath9k_platform_data"

