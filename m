Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:3881 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756431Ab2BFW7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 17:59:05 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 3/8] rt2x00: Update comment on freq_offset field in struct rt2x00_dev.
Date: Mon,  6 Feb 2012 23:45:08 +0100
Message-Id: <1328568313-26267-4-git-send-email-gwingerde@gmail.com> (sfid-20120206_235926_220887_ED4F0CB7)
In-Reply-To: <1328568313-26267-3-git-send-email-gwingerde@gmail.com>
References: <1328568313-26267-1-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-2-git-send-email-gwingerde@gmail.com>
 <1328568313-26267-3-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The comment states that the field is only used for rt61pci and rt73usb.
However, it is now used by rt2800pci and rt2800usb as well, so the
comment is not correct anymore.

Update the comment to not state any low-level drivers anymore.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 5bd2f22..ed2ae6e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -892,7 +892,7 @@ struct rt2x00_dev {
 	u8 rssi_offset;
 
 	/*
-	 * Frequency offset (for rt61pci & rt73usb).
+	 * Frequency offset.
 	 */
 	u8 freq_offset;
 
-- 
1.7.9

