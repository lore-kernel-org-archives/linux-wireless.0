Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:41791 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757077Ab3JKKuQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 06:50:16 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] rt2x00: cleanup indentation in rt2800.h
Date: Fri, 11 Oct 2013 12:50:08 +0200
Message-Id: <1381488608-23315-1-git-send-email-juhosg@openwrt.org> (sfid-20131011_125031_570432_85C14464)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adjust whitespaces to move badly aligned constants
to the right column.

The patch contains no functional changes.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800.h |   42 +++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index e3eb952..aab6b5e 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -124,7 +124,7 @@
 /*
  * MAC_CSR0_3290: MAC_CSR0 for RT3290 to identity MAC version number.
  */
-#define MAC_CSR0_3290				0x0000
+#define MAC_CSR0_3290			0x0000
 
 /*
  * E2PROM_CSR: PCI EEPROM control register.
@@ -213,17 +213,17 @@
 /*
  * COEX_CFG_0
  */
-#define COEX_CFG0			0x0040
+#define COEX_CFG0		0x0040
 #define COEX_CFG_ANT		FIELD32(0xff000000)
 /*
  * COEX_CFG_1
  */
-#define COEX_CFG1			0x0044
+#define COEX_CFG1		0x0044
 
 /*
  * COEX_CFG_2
  */
-#define COEX_CFG2			0x0048
+#define COEX_CFG2		0x0048
 #define BT_COEX_CFG1		FIELD32(0xff000000)
 #define BT_COEX_CFG0		FIELD32(0x00ff0000)
 #define WL_COEX_CFG1		FIELD32(0x0000ff00)
@@ -237,8 +237,8 @@
 #define PLL_RESERVED_INPUT2	FIELD32(0x0000ff00)
 #define PLL_CONTROL		FIELD32(0x00070000)
 #define PLL_LPF_R1		FIELD32(0x00080000)
-#define PLL_LPF_C1_CTRL	FIELD32(0x00300000)
-#define PLL_LPF_C2_CTRL	FIELD32(0x00c00000)
+#define PLL_LPF_C1_CTRL		FIELD32(0x00300000)
+#define PLL_LPF_C2_CTRL		FIELD32(0x00c00000)
 #define PLL_CP_CURRENT_CTRL	FIELD32(0x03000000)
 #define PLL_PFD_DELAY_CTRL	FIELD32(0x0c000000)
 #define PLL_LOCK_CTRL		FIELD32(0x70000000)
@@ -2166,7 +2166,7 @@ struct mac_iveiv_entry {
  */
 #define RFCSR6_R1			FIELD8(0x03)
 #define RFCSR6_R2			FIELD8(0x40)
-#define RFCSR6_TXDIV		FIELD8(0x0c)
+#define RFCSR6_TXDIV			FIELD8(0x0c)
 /* bits for RF3053 */
 #define RFCSR6_VCO_IC			FIELD8(0xc0)
 
@@ -2204,13 +2204,13 @@ struct mac_iveiv_entry {
  * RFCSR 12:
  */
 #define RFCSR12_TX_POWER		FIELD8(0x1f)
-#define RFCSR12_DR0				FIELD8(0xe0)
+#define RFCSR12_DR0			FIELD8(0xe0)
 
 /*
  * RFCSR 13:
  */
 #define RFCSR13_TX_POWER		FIELD8(0x1f)
-#define RFCSR13_DR0				FIELD8(0xe0)
+#define RFCSR13_DR0			FIELD8(0xe0)
 
 /*
  * RFCSR 15:
@@ -2228,7 +2228,7 @@ struct mac_iveiv_entry {
 #define RFCSR17_TXMIXER_GAIN		FIELD8(0x07)
 #define RFCSR17_TX_LO1_EN		FIELD8(0x08)
 #define RFCSR17_R			FIELD8(0x20)
-#define RFCSR17_CODE                   FIELD8(0x7f)
+#define RFCSR17_CODE			FIELD8(0x7f)
 
 /* RFCSR 18 */
 #define RFCSR18_XO_TUNE_BYPASS		FIELD8(0x40)
@@ -2451,7 +2451,7 @@ enum rt2800_eeprom_word {
  */
 #define EEPROM_NIC_CONF0_RXPATH		FIELD16(0x000f)
 #define EEPROM_NIC_CONF0_TXPATH		FIELD16(0x00f0)
-#define EEPROM_NIC_CONF0_RF_TYPE		FIELD16(0x0f00)
+#define EEPROM_NIC_CONF0_RF_TYPE	FIELD16(0x0f00)
 
 /*
  * EEPROM NIC Configuration 1
@@ -2473,18 +2473,18 @@ enum rt2800_eeprom_word {
  * DAC_TEST: 0: disable, 1: enable
  */
 #define EEPROM_NIC_CONF1_HW_RADIO		FIELD16(0x0001)
-#define EEPROM_NIC_CONF1_EXTERNAL_TX_ALC		FIELD16(0x0002)
-#define EEPROM_NIC_CONF1_EXTERNAL_LNA_2G		FIELD16(0x0004)
-#define EEPROM_NIC_CONF1_EXTERNAL_LNA_5G		FIELD16(0x0008)
+#define EEPROM_NIC_CONF1_EXTERNAL_TX_ALC	FIELD16(0x0002)
+#define EEPROM_NIC_CONF1_EXTERNAL_LNA_2G	FIELD16(0x0004)
+#define EEPROM_NIC_CONF1_EXTERNAL_LNA_5G	FIELD16(0x0008)
 #define EEPROM_NIC_CONF1_CARDBUS_ACCEL		FIELD16(0x0010)
 #define EEPROM_NIC_CONF1_BW40M_SB_2G		FIELD16(0x0020)
 #define EEPROM_NIC_CONF1_BW40M_SB_5G		FIELD16(0x0040)
 #define EEPROM_NIC_CONF1_WPS_PBC		FIELD16(0x0080)
 #define EEPROM_NIC_CONF1_BW40M_2G		FIELD16(0x0100)
 #define EEPROM_NIC_CONF1_BW40M_5G		FIELD16(0x0200)
-#define EEPROM_NIC_CONF1_BROADBAND_EXT_LNA		FIELD16(0x400)
+#define EEPROM_NIC_CONF1_BROADBAND_EXT_LNA	FIELD16(0x400)
 #define EEPROM_NIC_CONF1_ANT_DIVERSITY		FIELD16(0x1800)
-#define EEPROM_NIC_CONF1_INTERNAL_TX_ALC		FIELD16(0x2000)
+#define EEPROM_NIC_CONF1_INTERNAL_TX_ALC	FIELD16(0x2000)
 #define EEPROM_NIC_CONF1_BT_COEXIST		FIELD16(0x4000)
 #define EEPROM_NIC_CONF1_DAC_TEST		FIELD16(0x8000)
 
@@ -2523,9 +2523,9 @@ enum rt2800_eeprom_word {
  * TX_STREAM: 0: Reserved, 1: 1 Stream, 2: 2 Stream
  * CRYSTAL: 00: Reserved, 01: One crystal, 10: Two crystal, 11: Reserved
  */
-#define EEPROM_NIC_CONF2_RX_STREAM		FIELD16(0x000f)
-#define EEPROM_NIC_CONF2_TX_STREAM		FIELD16(0x00f0)
-#define EEPROM_NIC_CONF2_CRYSTAL		FIELD16(0x0600)
+#define EEPROM_NIC_CONF2_RX_STREAM	FIELD16(0x000f)
+#define EEPROM_NIC_CONF2_TX_STREAM	FIELD16(0x00f0)
+#define EEPROM_NIC_CONF2_CRYSTAL	FIELD16(0x0600)
 
 /*
  * EEPROM LNA
@@ -2792,7 +2792,7 @@ enum rt2800_eeprom_word {
 #define MCU_CURRENT			0x36
 #define MCU_LED				0x50
 #define MCU_LED_STRENGTH		0x51
-#define MCU_LED_AG_CONF		0x52
+#define MCU_LED_AG_CONF			0x52
 #define MCU_LED_ACT_CONF		0x53
 #define MCU_LED_LED_POLARITY		0x54
 #define MCU_RADAR			0x60
@@ -2801,7 +2801,7 @@ enum rt2800_eeprom_word {
 #define MCU_FREQ_OFFSET			0x74
 #define MCU_BBP_SIGNAL			0x80
 #define MCU_POWER_SAVE			0x83
-#define MCU_BAND_SELECT		0x91
+#define MCU_BAND_SELECT			0x91
 
 /*
  * MCU mailbox tokens
-- 
1.7.10
