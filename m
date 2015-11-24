Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44795 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbbKXRjO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2015 12:39:14 -0500
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/3] ath10k: introduce Mesh support in native WiFi mode for QCA988X
Date: Tue, 24 Nov 2015 09:37:32 -0800
Message-ID: <1448386655-13936-1-git-send-email-poh@qca.qualcomm.com> (sfid-20151124_183926_353495_10F27A9E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

QCA988X firmware has started supporting Mesh frame in native Wi-Fi mode
by adding its subtype since 10.2.4.70.12-2.
Hence update its WMI service map and vdev subtypes to be used for Mesh in
native Wi-Fi mode.

Peter Oh (3):
  ath10k: update WMI 10.x service map
  ath10k: introduce new subtypes for proxy STA and Mesh
  ath10k: apply Mesh subtype when Mesh interface created.

 drivers/net/wireless/ath/ath10k/mac.c |  4 +++-
 drivers/net/wireless/ath/ath10k/wmi.h | 17 +++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

-- 
1.9.1

