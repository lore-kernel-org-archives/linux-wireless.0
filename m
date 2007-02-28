Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:48635 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433AbXB1OHO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:14 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562562nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:13 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 24/28] rt2x00: Spellcheck for some comments.
Date: Wed, 28 Feb 2007 15:07:07 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.07711.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Spellcheck for some comments.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index 5ad5d75..29a8203 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -114,7 +114,7 @@ static void rt2x00_bbp_write(const struct rt2x00_dev *rt2x00dev,
 	u32 reg;
 
 	/*
-	 *  Wait untill the BBP becomes ready.
+	 *  Wait until the BBP becomes ready.
 	 */
 	if (rt2x00_bbp_check(rt2x00dev) == 0xffff) {
 		ERROR("BBPCSR register busy. Write failed.\n");
@@ -139,7 +139,7 @@ static void rt2x00_bbp_read(const struct rt2x00_dev *rt2x00dev,
 	u32 reg;
 
 	/*
-	 *  Wait untill the BBP becomes ready.
+	 *  Wait until the BBP becomes ready.
 	 */
 	if (rt2x00_bbp_check(rt2x00dev) == 0xffff) {
 		ERROR("BBPCSR register busy. Read failed.\n");
@@ -157,7 +157,7 @@ static void rt2x00_bbp_read(const struct rt2x00_dev *rt2x00dev,
 	rt2x00_register_write(rt2x00dev, BBPCSR, reg);
 
 	/*
-	 *  Wait untill the BBP becomes ready.
+	 *  Wait until the BBP becomes ready.
 	 */
 	reg = rt2x00_bbp_check(rt2x00dev);
 	if (reg == 0xffff)
@@ -746,8 +746,8 @@ static int rt2400pci_set_state(struct rt2x00_dev *rt2x00dev,
 	rt2x00_register_write(rt2x00dev, PWRCSR1, reg);
 
 	/*
-	 * Device is not guarenteed to be in the requested state yet.
-	 * We must wait untill the register indicates that the
+	 * Device is not guaranteed to be in the requested state yet.
+	 * We must wait until the register indicates that the
 	 * device has entered the correct state.
 	 */
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index 9763da5..e5d032c 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -114,7 +114,7 @@ static void rt2x00_bbp_write(const struct rt2x00_dev *rt2x00dev,
 	u32 reg;
 
 	/*
-	 *  Wait untill the BBP becomes ready.
+	 *  Wait until the BBP becomes ready.
 	 */
 	if (rt2x00_bbp_check(rt2x00dev) == 0xffff) {
 		ERROR("BBPCSR register busy. Write failed.\n");
@@ -139,7 +139,7 @@ static void rt2x00_bbp_read(const struct rt2x00_dev *rt2x00dev,
 	u32 reg;
 
 	/*
-	 *  Wait untill the BBP becomes ready.
+	 *  Wait until the BBP becomes ready.
 	 */
 	if (rt2x00_bbp_check(rt2x00dev) == 0xffff) {
 		ERROR("BBPCSR register busy. Read failed.\n");
@@ -157,7 +157,7 @@ static void rt2x00_bbp_read(const struct rt2x00_dev *rt2x00dev,
 	rt2x00_register_write(rt2x00dev, BBPCSR, reg);
 
 	/*
-	 *  Wait untill the BBP becomes ready.
+	 *  Wait until the BBP becomes ready.
 	 */
 	reg = rt2x00_bbp_check(rt2x00dev);
 	if (reg == 0xffff)
@@ -720,7 +720,7 @@ static void rt2500pci_link_tuner(struct work_struct *work)
 		return;
 
 	/*
-	 * Retreive link quality.
+	 * Retrieve link quality.
 	 */
 	rssi = rt2x00_get_link_rssi(&rt2x00dev->link);
 	if (!rssi)
@@ -837,8 +837,8 @@ static int rt2500pci_set_state(struct rt2x00_dev *rt2x00dev,
 	rt2x00_register_write(rt2x00dev, PWRCSR1, reg);
 
 	/*
-	 * Device is not guarenteed to be in the requested state yet.
-	 * We must wait untill the register indicates that the
+	 * Device is not guaranteed to be in the requested state yet.
+	 * We must wait until the register indicates that the
 	 * device has entered the correct state.
 	 */
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index bfad5a6..86846a1 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -150,7 +150,7 @@ static void rt2x00_bbp_write(const struct rt2x00_dev *rt2x00dev,
 	u16 reg;
 
 	/*
-	 *  Wait untill the BBP becomes ready.
+	 *  Wait until the BBP becomes ready.
 	 */
 	if (rt2x00_bbp_check(rt2x00dev) == 0xffff) {
 		ERROR("PHY_CSR8 register busy. Write failed.\n");
@@ -174,7 +174,7 @@ static void rt2x00_bbp_read(const struct rt2x00_dev *rt2x00dev,
 	u16 reg;
 
 	/*
-	 *  Wait untill the BBP becomes ready.
+	 *  Wait until the BBP becomes ready.
 	 */
 	if (rt2x00_bbp_check(rt2x00dev) == 0xffff) {
 		ERROR("PHY_CSR8 register busy. Read failed.\n");
@@ -191,7 +191,7 @@ static void rt2x00_bbp_read(const struct rt2x00_dev *rt2x00dev,
 	rt2x00_register_write(rt2x00dev, PHY_CSR7, reg);
 
 	/*
-	 *  Wait untill the BBP becomes ready.
+	 *  Wait until the BBP becomes ready.
 	 */
 	if (rt2x00_bbp_check(rt2x00dev) == 0xffff) {
 		ERROR("PHY_CSR8 register busy. Read failed.\n");
@@ -740,7 +740,7 @@ static void rt2500usb_link_tuner(struct work_struct *work)
 		return;
 
 	/*
-	 * Retreive link quality.
+	 * Retrieve link quality.
 	 */
 	rssi = rt2x00_get_link_rssi(&rt2x00dev->link);
 	if (!rssi)
@@ -864,8 +864,8 @@ static int rt2500usb_set_state(struct rt2x00_dev *rt2x00dev,
 	rt2x00_register_write(rt2x00dev, MAC_CSR17, reg);
 
 	/*
-	 * Device is not guarenteed to be in the requested state yet.
-	 * We must wait untill the register indicates that the
+	 * Device is not guaranteed to be in the requested state yet.
+	 * We must wait until the register indicates that the
 	 * device has entered the correct state.
 	 */
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index ec149d1..f160e66 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -120,7 +120,7 @@ static void rt2x00_bbp_write(const struct rt2x00_dev *rt2x00dev,
 	u32 reg;
 
 	/*
-	 *  Wait untill the BBP becomes ready.
+	 *  Wait until the BBP becomes ready.
 	 */
 	if (rt2x00_bbp_check(rt2x00dev) == 0xffff) {
 		ERROR("PHY_CSR3 register busy. Write failed.\n");
@@ -145,7 +145,7 @@ static void rt2x00_bbp_read(const struct rt2x00_dev *rt2x00dev,
 	u32 reg;
 
 	/*
-	 *  Wait untill the BBP becomes ready.
+	 *  Wait until the BBP becomes ready.
 	 */
 	if (rt2x00_bbp_check(rt2x00dev) == 0xffff) {
 		ERROR("PHY_CSR3 register busy. Read failed.\n");
@@ -163,7 +163,7 @@ static void rt2x00_bbp_read(const struct rt2x00_dev *rt2x00dev,
 	rt2x00_register_write(rt2x00dev, PHY_CSR3, reg);
 
 	/*
-	 *  Wait untill the BBP becomes ready.
+	 *  Wait until the BBP becomes ready.
 	 */
 	reg = rt2x00_bbp_check(rt2x00dev);
 	if (reg == 0xffff)
@@ -948,7 +948,7 @@ static void rt61pci_link_tuner(struct work_struct *work)
 	u8 low_bound;
 
 	/*
-	 * Retreive link quality.
+	 * Retrieve link quality.
 	 */
 	rssi = rt2x00_get_link_rssi(&rt2x00dev->link);
 	if (!rssi)
@@ -960,7 +960,7 @@ static void rt61pci_link_tuner(struct work_struct *work)
 	rt61pci_activity_led(rt2x00dev, rssi);
 
 	/*
-	 * Determine upper and lower limit for BBP17 register.
+	 * Determine upper and lower limits for BBP17 register.
 	 */
 	if (rt2x00dev->rx_status.phymode == MODE_IEEE80211A) {
 		up_bound = 0x48;
@@ -1111,8 +1111,8 @@ static int rt61pci_set_state(struct rt2x00_dev *rt2x00dev,
 	}
 
 	/*
-	 * Device is not guarenteed to be in the requested state yet.
-	 * We must wait untill the register indicates that the
+	 * Device is not guaranteed to be in the requested state yet.
+	 * We must wait until the register indicates that the
 	 * device has entered the correct state.
 	 */
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index ffecc64..e75a478 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -152,7 +152,7 @@ static void rt2x00_bbp_write(const struct rt2x00_dev *rt2x00dev,
 	u32 reg;
 
 	/*
-	 *  Wait untill the BBP becomes ready.
+	 *  Wait until the BBP becomes ready.
 	 */
 	if (rt2x00_bbp_check(rt2x00dev) == 0xffff) {
 		ERROR("PHY_CSR3 register busy. Write failed.\n");
@@ -177,7 +177,7 @@ static void rt2x00_bbp_read(const struct rt2x00_dev *rt2x00dev,
 	u32 reg;
 
 	/*
-	 *  Wait untill the BBP becomes ready.
+	 *  Wait until the BBP becomes ready.
 	 */
 	if (rt2x00_bbp_check(rt2x00dev) == 0xffff) {
 		ERROR("PHY_CSR3 register busy. Read failed.\n");
@@ -195,7 +195,7 @@ static void rt2x00_bbp_read(const struct rt2x00_dev *rt2x00dev,
 	rt2x00_register_write(rt2x00dev, PHY_CSR3, reg);
 
 	/*
-	 *  Wait untill the BBP becomes ready.
+	 *  Wait until the BBP becomes ready.
 	 */
 	reg = rt2x00_bbp_check(rt2x00dev);
 	if (reg == 0xffff)
@@ -845,7 +845,7 @@ static void rt73usb_link_tuner(struct work_struct *work)
 	u8 low_bound;
 
 	/*
-	 * Retreive link quality.
+	 * Retrieve link quality.
 	 */
 	rssi = rt2x00_get_link_rssi(&rt2x00dev->link);
 	if (!rssi)
@@ -857,7 +857,7 @@ static void rt73usb_link_tuner(struct work_struct *work)
 	rt73usb_activity_led(rt2x00dev, rssi);
 
 	/*
-	 * Determine upper and lower limit for BBP17 register.
+	 * Determine upper and lower limits for BBP17 register.
 	 */
 	if (rt2x00dev->rx_status.phymode == MODE_IEEE80211A) {
 		up_bound = 0x48;
@@ -1018,8 +1018,8 @@ static int rt73usb_set_state(struct rt2x00_dev *rt2x00dev,
 			0x00, USB_MODE_SLEEP, NULL, 0, REGISTER_TIMEOUT);
 
 	/*
-	 * Device is not guarenteed to be in the requested state yet.
-	 * We must wait untill the register indicates that the
+	 * Device is not guaranteed to be in the requested state yet.
+	 * We must wait until the register indicates that the
 	 * device has entered the correct state.
 	 */
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
