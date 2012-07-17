Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:45189 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753761Ab2GQOPu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 10:15:50 -0400
Message-ID: <19811dfd94388fb6406373822974cee7.squirrel@www.infidigm.net> (sfid-20120717_161554_221038_75D25AAB)
In-Reply-To: <4FFD7621.5020207@qca.qualcomm.com>
References: <43a66e0f20b45e9cc461272e83f2c4e4.squirrel@www.infidigm.net>
    <4FFC08C5.2050606@qca.qualcomm.com>
    <71781241c331fcbb5687068ddc6bbb06.squirrel@www.infidigm.net>
    <4FFD7621.5020207@qca.qualcomm.com>
Date: Tue, 17 Jul 2012 10:53:07 -0400
Subject: ath6kl: Add support for AR6004 hardware version 1.3
From: drwho@infidigm.net
To: bkamatch@qca.qualcomm.com, "Kalle Valo" <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	"ath6kl-devel" <ath6kl-devel@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Would it be possible to get hw1.3 pushed up to linux-firmware git?

Jon

Add support for AR6004 hardware with version 1.3 and has
id 0x31c8088a.

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    7 +++++++
 drivers/net/wireless/ath/ath6kl/init.c |   20 ++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/sdio.c |    3 +++
 drivers/net/wireless/ath/ath6kl/usb.c  |    3 +++
 4 files changed, 33 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h
b/drivers/net/wireless/ath/ath6kl/core.h
index c655438..2d1b8ac 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -192,6 +192,13 @@ enum ath6kl_hw_flags {
 #define AR6004_HW_1_2_DEFAULT_BOARD_DATA_FILE \
 	AR6004_HW_1_2_FW_DIR "/bdata.bin"

+/* AR6004 1.3 definitions */
+#define AR6004_HW_1_3_VERSION			0x31c8088a
+#define AR6004_HW_1_3_FW_DIR			"ath6k/AR6004/hw1.3"
+#define AR6004_HW_1_3_FIRMWARE_FILE		"fw.ram.bin"
+#define AR6004_HW_1_3_BOARD_DATA_FILE		"ath6k/AR6004/hw1.3/bdata.bin"
+#define AR6004_HW_1_3_DEFAULT_BOARD_DATA_FILE	"ath6k/AR6004/hw1.3/bdata.bin"

