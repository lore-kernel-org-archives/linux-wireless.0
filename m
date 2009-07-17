Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:63563 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbZGQTj0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 15:39:26 -0400
Received: by ewy26 with SMTP id 26so1111632ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2009 12:39:24 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
Subject: [PATCH] rt2x00: Comment spellchecking
Date: Fri, 17 Jul 2009 21:39:19 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200907172139.21122.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis Correia <luis.f.correia@gmail.com>

Fix a bunch of spelling errors in the rt2x00 drivers

Signed-off-by: Luis Correia <luis.f.correia@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
index ec3b004..ccd6441 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/rt2x00/rt2400pci.h
@@ -928,7 +928,7 @@
 #define RXD_W7_RESERVED			FIELD32(0xffffffff)
 
 /*
- * Macro's for converting txpower from EEPROM to mac80211 value
+ * Macros for converting txpower from EEPROM to mac80211 value
  * and from mac80211 value to register value.
  * NOTE: Logics in rt2400pci for txpower are reversed
  * compared to the other rt2x00 drivers. A higher txpower
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.h b/drivers/net/wireless/rt2x00/rt2500pci.h
index ce2f065..54d3795 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/rt2x00/rt2500pci.h
@@ -1218,7 +1218,7 @@
 #define RXD_W10_DROP			FIELD32(0x00000001)
 
 /*
- * Macro's for converting txpower from EEPROM to mac80211 value
+ * Macros for converting txpower from EEPROM to mac80211 value
  * and from mac80211 value to register value.
  */
 #define MIN_TXPOWER	0
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
index 5bc46fe..b01edca 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -831,7 +831,7 @@
 #define RXD_W3_EIV			FIELD32(0xffffffff)
 
 /*
- * Macro's for converting txpower from EEPROM to mac80211 value
+ * Macros for converting txpower from EEPROM to mac80211 value
  * and from mac80211 value to register value.
  */
 #define MIN_TXPOWER	0
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index a204e66..d356de4 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1910,7 +1910,7 @@ static int rt2800usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		/*
 		 * Before the radio can be enabled, the device first has
 		 * to be woken up. After that it needs a bit of time
-		 * to be fully awake and the radio can be enabled.
+		 * to be fully awake and then the radio can be enabled.
 		 */
 		rt2800usb_set_state(rt2x00dev, STATE_AWAKE);
 		msleep(1);
@@ -1918,7 +1918,7 @@ static int rt2800usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		break;
 	case STATE_RADIO_OFF:
 		/*
-		 * After the radio has been disablee, the device should
+		 * After the radio has been disabled, the device should
 		 * be put to sleep for powersaving.
 		 */
 		rt2800usb_disable_radio(rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.h b/drivers/net/wireless/rt2x00/rt2800usb.h
index 61a8be6..2d9dc37 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.h
+++ b/drivers/net/wireless/rt2x00/rt2800usb.h
@@ -1921,7 +1921,7 @@ struct mac_iveiv_entry {
 #define RXWI_W3_SNR1			FIELD32(0x0000ff00)
 
 /*
- * Macro's for converting txpower from EEPROM to mac80211 value
+ * Macros for converting txpower from EEPROM to mac80211 value
  * and from mac80211 value to register value.
  */
 #define MIN_G_TXPOWER	0
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index de3f13a..2abb085 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -251,7 +251,7 @@ struct link_ant {
 	struct antenna_setup active;
 
 	/*
-	 * RSSI information for the different antenna's.
+	 * RSSI information for the different antennas.
 	 * These statistics are used to determine when
 	 * to switch antenna when using software diversity.
 	 *
@@ -640,7 +640,7 @@ struct rt2x00_dev {
 	 * The structure stored in here depends on the
 	 * system bus (PCI or USB).
 	 * When accessing this variable, the rt2x00dev_{pci,usb}
-	 * macro's should be used for correct typecasting.
+	 * macros should be used for correct typecasting.
 	 */
 	struct device *dev;
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 3e019a1..c6e0bcf 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -132,7 +132,7 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Failsafe: Make sure we are not sending the
 	 * ANTENNA_SW_DIVERSITY state to the driver.
-	 * If that happes fallback to hardware default,
+	 * If that happens, fallback to hardware defaults,
 	 * or our own default.
 	 * The calls to rt2x00lib_config_antenna_check()
 	 * might have caused that we restore back to the already
diff --git a/drivers/net/wireless/rt2x00/rt2x00crypto.c b/drivers/net/wireless/rt2x00/rt2x00crypto.c
index c54eda3..30fbd3b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00crypto.c
+++ b/drivers/net/wireless/rt2x00/rt2x00crypto.c
@@ -129,7 +129,7 @@ void rt2x00crypto_tx_remove_iv(struct sk_buff *skb, struct txentry_desc *txdesc)
 	/* Pull buffer to correct size */
 	skb_pull(skb, txdesc->iv_len);
 
-	/* IV/EIV data has officially be stripped */
+	/* IV/EIV data has officially been stripped */
 	skbdesc->flags |= SKBDESC_IV_STRIPPED;
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index eb9b981..3257075 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -158,7 +158,7 @@ static void rt2x00lib_antenna_diversity_sample(struct rt2x00_dev *rt2x00dev)
 
 	/*
 	 * During the last period we have sampled the RSSI
-	 * from both antenna's. It now is time to determine
+	 * from both antennas. It now is time to determine
 	 * which antenna demonstrated the best performance.
 	 * When we are already on the antenna with the best
 	 * performance, then there really is nothing for us
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index b7e0ddd..54fd2e8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -341,7 +341,7 @@ int rt2x00mac_config(struct ieee80211_hw *hw, u32 changed)
 	int status;
 
 	/*
-	 * Mac80211 might be calling this function while we are trying
+	 * mac80211 might be calling this function while we are trying
 	 * to remove the device or perhaps suspending it.
 	 */
 	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
@@ -577,7 +577,7 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 	int update_bssid = 0;
 
 	/*
-	 * Mac80211 might be calling this function while we are trying
+	 * mac80211 might be calling this function while we are trying
 	 * to remove the device or perhaps suspending it.
 	 */
 	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index b5e0634..47d175a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -29,7 +29,7 @@
 #include <linux/prefetch.h>
 
 /**
- * DOC: Entrie frame size
+ * DOC: Entry frame size
  *
  * Ralink PCI devices demand the Frame size to be a multiple of 128 bytes,
  * for USB devices this restriction does not apply, but the value of
@@ -45,13 +45,13 @@
 /**
  * DOC: Number of entries per queue
  *
- * Under normal load without fragmentation 12 entries are sufficient
+ * Under normal load without fragmentation, 12 entries are sufficient
  * without the queue being filled up to the maximum. When using fragmentation
- * and the queue threshold code we need to add some additional margins to
+ * and the queue threshold code, we need to add some additional margins to
  * make sure the queue will never (or only under extreme load) fill up
  * completely.
- * Since we don't use preallocated DMA having a large number of queue entries
- * will have only minimal impact on the memory requirements for the queue.
+ * Since we don't use preallocated DMA, having a large number of queue entries
+ * will have minimal impact on the memory requirements for the queue.
  */
 #define RX_ENTRIES	24
 #define TX_ENTRIES	24
diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index 861322d..983e52e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -176,8 +176,8 @@ struct rt2x00_field32 {
 #define is_valid_mask(x)	is_power_of_two(1LU + (x) + low_bit_mask(x))
 
 /*
- * Macro's to find first set bit in a variable.
- * These macro's behaves the same as the __ffs() function with
+ * Macros to find first set bit in a variable.
+ * These macros behave the same as the __ffs() functions but
  * the most important difference that this is done during
  * compile-time rather then run-time.
  */
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 8a49d99..4bbbd13 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2312,7 +2312,7 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	}
 
 	/*
-	 * Determine number of antenna's.
+	 * Determine number of antennas.
 	 */
 	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_NUM) == 2)
 		__set_bit(CONFIG_DOUBLE_ANTENNA, &rt2x00dev->flags);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index 6c71f77..93eb699 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -1476,7 +1476,7 @@ struct hw_pairwise_ta_entry {
 #define RXD_W15_RESERVED		FIELD32(0xffffffff)
 
 /*
- * Macro's for converting txpower from EEPROM to mac80211 value
+ * Macros for converting txpower from EEPROM to mac80211 value
  * and from mac80211 value to register value.
  */
 #define MIN_TXPOWER	0
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
index c8016f6..81fe0be 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -809,7 +809,7 @@ struct hw_pairwise_ta_entry {
 
 /*
  * EEPROM antenna.
- * ANTENNA_NUM: Number of antenna's.
+ * ANTENNA_NUM: Number of antennas.
  * TX_DEFAULT: Default antenna 0: diversity, 1: A, 2: B.
  * RX_DEFAULT: Default antenna 0: diversity, 1: A, 2: B.
  * FRAME_TYPE: 0: DPDT , 1: SPDT , noted this bit is valid for g only.
@@ -1058,7 +1058,7 @@ struct hw_pairwise_ta_entry {
 #define RXD_W5_RESERVED			FIELD32(0xffffffff)
 
 /*
- * Macro's for converting txpower from EEPROM to mac80211 value
+ * Macros for converting txpower from EEPROM to mac80211 value
  * and from mac80211 value to register value.
  */
 #define MIN_TXPOWER	0
