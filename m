Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:39929 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbbAHLMw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2015 06:12:52 -0500
Received: by mail-wg0-f48.google.com with SMTP id l2so1970285wgh.7
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2015 03:12:51 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/5] ath10k: implement beacon offload
Date: Thu,  8 Jan 2015 12:12:25 +0100
Message-Id: <1420715550-16017-1-git-send-email-michal.kazior@tieto.com> (sfid-20150108_121255_919395_363D4C7A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

New wmi-tlv firmware will support beacon/presp
offloading. This patchset adds appropriate
support.

These patches of mine were originally posted by
Bartosz before christmas after I went on my
holidays.

v2:
 * add a comment in patch 5


Michal Kazior (5):
  ath10k: implement new beacon tx status event
  ath10k: implement beacon template command
  ath10k: implement prb tmpl wmi command
  ath10k: implement p2p bcn ie command
  ath10k: implement support for ap beacon offloading

 drivers/net/wireless/ath/ath10k/mac.c     | 162 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  57 +++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 206 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  34 +++++
 drivers/net/wireless/ath/ath10k/wmi.c     |   9 ++
 5 files changed, 468 insertions(+)

-- 
1.8.5.3

