Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:48061 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaLQPWP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 10:22:15 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so16480401wiv.7
        for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2014 07:22:14 -0800 (PST)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 0/5] ath10k: new beaconning methods for AP/GO/IBSS
Date: Wed, 17 Dec 2014 16:21:46 +0100
Message-Id: <1418829711-19713-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20141217_162218_629304_3FE49896)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a continuation of the new wmi-tlv backed series from Michal,
preparing for a new hardware support for ath10k.

I'm sending this for a first review round, since Michal has started
his holiday break already.

Michal Kazior (5):
  ath10k: implement new beacon tx status event
  ath10k: implement beacon template command
  ath10k: implement prb tmpl wmi command
  ath10k: implement p2p bcn ie command
  ath10k: implement support for ap beacon offloading

 drivers/net/wireless/ath/ath10k/mac.c     | 158 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  57 +++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 206 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  34 +++++
 drivers/net/wireless/ath/ath10k/wmi.c     |   9 ++
 5 files changed, 464 insertions(+)

-- 
1.8.2

