Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34530 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbcFWRpu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 13:45:50 -0400
Received: by mail-wm0-f66.google.com with SMTP id 187so12836087wmz.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2016 10:45:50 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Cc: nbd@nbd.name, chunkeey@googlemail.com, mark.rutland@arm.com,
	robh+dt@kernel.org
Subject: [RFC v2] ath9k: add devicetree support to ath9k
Date: Thu, 23 Jun 2016 19:45:34 +0200
Message-Id: <20160623174536.5967-1-martin.blumenstingl@googlemail.com> (sfid-20160623_194554_565491_A1EFE0D2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds support for configuring ath9k based devices via
devicetree. This was tested on PCI(e) based devices. This should work
for AHB based devices as well as soon as the ath79 platform is ready
to populate the ath9k wmac via devicetree.

This series depends on my previous series:
"ath9k: extend and improve handling of ath9k_platform_data"

changes in v1 -> v2:
This addresses all issues found by Christian Lamparter (thanks!), the
detailed changes are documented in each patch.


