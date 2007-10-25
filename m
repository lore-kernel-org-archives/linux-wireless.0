Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:53109 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbXJYJW3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:22:29 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ian Schram <ischram@telenet.be>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 01/30] iwlwifi: fix various spelling and typos
Date: Thu, 25 Oct 2007 17:15:22 +0800
Message-Id: <11933037512140-git-send-email-yi.zhu@intel.com> (sfid-20071025_102236_259369_9439787F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ian Schram <ischram@telenet.be>

Fixing various spelling errors and typos. Mostly in comments. In total
27 words were corrected, some of which occurred more than ones.

Signed-Of-By: Ian Schram <ischram@telenet.be>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.h  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c  |    6 ++--
 drivers/net/wireless/iwlwifi/iwl-4965-rs.h  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-hw.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   32 +++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   32 +++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwlwifi.h      |    6 ++--
 14 files changed, 52 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index fb5f064..90d4249 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -8,7 +8,7 @@
  * Copyright(c) 2005 - 2007 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU Geeral Public License as
+ * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
  *
  * This program is distributed in the hope that it will be useful, but
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index ad13475..f292880 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -358,7 +358,7 @@ static void *rs_alloc(struct ieee80211_local *local)
 	return local->hw.priv;
 }
 
-/* rate scale requires free function to be implmented */
+/* rate scale requires free function to be implemented */
 static void rs_free(void *priv)
 {
 	return;
@@ -551,7 +551,7 @@ static u16 iwl_get_adjacent_rate(struct iwl_rate_scale_priv *rs_priv,
 	u8 high = IWL_RATE_INVALID;
 	u8 low = IWL_RATE_INVALID;
 
-	/* 802.11A walks to the next literal adjascent rate in
+	/* 802.11A walks to the next literal adjacent rate in
 	 * the rate table */
 	if (unlikely(phymode == MODE_IEEE80211A)) {
 		int i;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.h b/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
index b926738..09fa1a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
@@ -155,7 +155,7 @@ static inline u8 iwl_get_prev_ieee_rate(u8 rate_index)
  * iwl_fill_rs_info - Fill an output text buffer with the rate representation
  *
  * NOTE:  This is provided as a quick mechanism for a user to visualize
- * the performance of the rate control alogirthm and is not meant to be
+ * the performance of the rate control algorithm and is not meant to be
  * parsed software.
  */
 extern int iwl_fill_rs_info(struct ieee80211_hw *, char *buf, u8 sta_id);
@@ -163,7 +163,7 @@ extern int iwl_fill_rs_info(struct ieee80211_hw *, char *buf, u8 sta_id);
 /**
  * iwl_rate_scale_init - Initialize the rate scale table based on assoc info
  *
- * The specific througput table used is based on the type of network
+ * The specific throughput table used is based on the type of network
  * the associated with, including A, B, G, and G w/ TGG protection
  */
 extern void iwl_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 99a19ef..6a2df9d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -8,7 +8,7 @@
  * Copyright(c) 2005 - 2007 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU Geeral Public License as
+ * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
  *
  * This program is distributed in the hope that it will be useful, but
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 3762cef..e80f5e2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -498,7 +498,7 @@ static u16 rs_get_adjacent_rate(u8 index, u16 rate_mask, int rate_type)
 	u8 high = IWL_RATE_INVALID;
 	u8 low = IWL_RATE_INVALID;
 
-	/* 802.11A or ht walks to the next literal adjascent rate in
+	/* 802.11A or ht walks to the next literal adjacent rate in
 	 * the rate table */
 	if (is_a_band(rate_type) || !is_legacy(rate_type)) {
 		int i;
@@ -1413,7 +1413,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		index = IWL_INVALID_VALUE;
 		update_lq = 1;
 
-		/* get the lowest availabe rate */
+		/* get the lowest available rate */
 		for (i = 0; i <= IWL_RATE_COUNT; i++) {
 			if ((1 << i) & rate_scale_index_msk)
 				index = i;
@@ -2268,7 +2268,7 @@ int iwl_fill_rs_info(struct ieee80211_hw *hw, char *buf, u8 sta_id)
 			 max_time, good * 100 / samples, good, samples);
 	else
 		count += sprintf(&buf[count], "\nAverage rate: 0Mbs\n");
-	count += sprintf(&buf[count], "\nrate scale type %d anntena %d "
+	count += sprintf(&buf[count], "\nrate scale type %d antenna %d "
 			 "active_search %d rate index %d\n", lq_type, antenna,
 			 rs_priv->search_better_tbl, sta->last_txrate);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.h b/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
index c6325f7..f735752 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
@@ -230,7 +230,7 @@ extern int iwl_rate_index_from_plcp(int plcp);
  * iwl_fill_rs_info - Fill an output text buffer with the rate representation
  *
  * NOTE:  This is provided as a quick mechanism for a user to visualize
- * the performance of the rate control alogirthm and is not meant to be
+ * the performance of the rate control algorithm and is not meant to be
  * parsed software.
  */
 extern int iwl_fill_rs_info(struct ieee80211_hw *, char *buf, u8 sta_id);
@@ -238,7 +238,7 @@ extern int iwl_fill_rs_info(struct ieee80211_hw *, char *buf, u8 sta_id);
 /**
  * iwl_rate_scale_init - Initialize the rate scale table based on assoc info
  *
- * The specific througput table used is based on the type of network
+ * The specific throughput table used is based on the type of network
  * the associated with, including A, B, G, and G w/ TGG protection
  */
 extern void iwl_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 4f306fa..efb1162 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4046,7 +4046,7 @@ static int iwl4965_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 	agg->wait_for_ba = 0;
 	IWL_DEBUG_TX_REPLY("BA %d %d\n", agg->start_idx, ba_resp->ba_seq_ctl);
 	sh = agg->start_idx - SEQ_TO_INDEX(ba_seq_ctl>>4);
-	if (sh < 0) /* tbw something is wrong with indeces */
+	if (sh < 0) /* tbw something is wrong with indices */
 		sh += 0x100;
 
 	/* don't use 64 bits for now */
@@ -4104,7 +4104,7 @@ static void iwl4965_rx_reply_compressed_ba(struct iwl_priv *priv,
 	agg = &priv->stations[ba_resp->sta_id].tid[ba_resp->tid].agg;
 	index = iwl_queue_dec_wrap(ba_resp_scd_ssn & 0xff, txq->q.n_bd);
 
-	/* TODO: Need to get this copy more sefely - now good for debug */
+	/* TODO: Need to get this copy more safely - now good for debug */
 /*
 	IWL_DEBUG_TX_REPLY("REPLY_COMPRESSED_BA [%d]Received from " MAC_FMT ",
 			   sta_id = %d\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 9de8d7f..d852a77 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -8,7 +8,7 @@
  * Copyright(c) 2005 - 2007 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU Geeral Public License as
+ * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
  *
  * This program is distributed in the hope that it will be useful, but
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index e473c97..22cbe27 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -8,7 +8,7 @@
  * Copyright(c) 2005 - 2007 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU Geeral Public License as
+ * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
  *
  * This program is distributed in the hope that it will be useful, but
diff --git a/drivers/net/wireless/iwlwifi/iwl-hw.h b/drivers/net/wireless/iwlwifi/iwl-hw.h
index 1aa6fcd..8968a95 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-hw.h
@@ -8,7 +8,7 @@
  * Copyright(c) 2005 - 2007 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU Geeral Public License as
+ * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
  *
  * This program is distributed in the hope that it will be useful, but
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 0df4114..b1b5233 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -8,7 +8,7 @@
  * Copyright(c) 2005 - 2007 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU Geeral Public License as
+ * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
  *
  * This program is distributed in the hope that it will be useful, but
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 05e1135..d0918f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -287,7 +287,7 @@ static int iwl_tx_queue_alloc(struct iwl_priv *priv,
 		txq->txb = kmalloc(sizeof(txq->txb[0]) *
 				   TFD_QUEUE_SIZE_MAX, GFP_KERNEL);
 		if (!txq->txb) {
-			IWL_ERROR("kmalloc for auxilary BD "
+			IWL_ERROR("kmalloc for auxiliary BD "
 				  "structures failed\n");
 			goto error;
 		}
@@ -323,7 +323,7 @@ int iwl_tx_queue_init(struct iwl_priv *priv,
 	int len;
 	int rc = 0;
 
-	/* alocate command space + one big command for scan since scan
+	/* allocate command space + one big command for scan since scan
 	 * command is very huge the system will not have two scan at the
 	 * same time */
 	len = sizeof(struct iwl_cmd) * slots_num;
@@ -405,7 +405,7 @@ const u8 BROADCAST_ADDR[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
  */
 
 /**************************************************************/
-#if 0 /* temparary disable till we add real remove station */
+#if 0 /* temporary disable till we add real remove station */
 static u8 iwl_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 {
 	int index = IWL_INVALID_STATION;
@@ -481,7 +481,7 @@ u8 iwl_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap, u8 flags)
 				index = i;
 		}
 
-	/* These twh conditions has the same outcome but keep them separate
+	/* These two conditions has the same outcome but keep them separate
 	  since they have different meaning */
 	if (unlikely(index == IWL_INVALID_STATION)) {
 		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
@@ -958,7 +958,7 @@ static int iwl_check_rxon_cmd(struct iwl_rxon_cmd *rxon)
 
 /**
  * iwl_full_rxon_required - determine if RXON_ASSOC can be used in RXON commit
- * @priv: staging_rxon is comapred to active_rxon
+ * @priv: staging_rxon is compared to active_rxon
  *
  * If the RXON structure is changing sufficient to require a new
  * tune or to clear and reset the RXON_FILTER_ASSOC_MSK then return 1
@@ -1046,7 +1046,7 @@ static int iwl_send_rxon_assoc(struct iwl_priv *priv)
 /**
  * iwl_commit_rxon - commit staging_rxon to hardware
  *
- * The RXON command in staging_rxon is commited to the hardware and
+ * The RXON command in staging_rxon is committed to the hardware and
  * the active_rxon structure is updated with the new data.  This
  * function correctly transitions out of the RXON_ASSOC_MSK state if
  * a HW tune is required based on the RXON structure changes.
@@ -2148,7 +2148,7 @@ static int iwl_send_power_mode(struct iwl_priv *priv, u32 mode)
 	struct iwl_powertable_cmd cmd;
 
 	/* If on battery, set to 3,
-	 * if plugged into AC power, set to CAM ("continuosly aware mode"),
+	 * if plugged into AC power, set to CAM ("continuously aware mode"),
 	 * else user level */
 	switch (mode) {
 	case IWL_POWER_BATTERY:
@@ -2438,7 +2438,7 @@ static void iwl_set_flags_for_phymode(struct iwl_priv *priv, u8 phymode)
 }
 
 /*
- * initilize rxon structure with default values fromm eeprom
+ * initialize rxon structure with default values from eeprom
  */
 static void iwl_connection_init_rx_config(struct iwl_priv *priv)
 {
@@ -2700,7 +2700,7 @@ static int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 		return priv->hw_setting.bcast_sta_id;
 
 	default:
-		IWL_WARNING("Unkown mode of operation: %d", priv->iw_mode);
+		IWL_WARNING("Unknown mode of operation: %d", priv->iw_mode);
 		return priv->hw_setting.bcast_sta_id;
 	}
 }
@@ -3880,7 +3880,7 @@ static void iwl_tx_cmd_complete(struct iwl_priv *priv,
  * The management in the driver is as follows:
  * + A list of pre-allocated SKBs is stored in iwl->rxq->rx_free.  When
  *   iwl->rxq->free_count drops to or below RX_LOW_WATERMARK, work is scheduled
- *   to replensish the iwl->rxq->rx_free.
+ *   to replenish the iwl->rxq->rx_free.
  * + In iwl_rx_replenish (scheduled) if 'processed' != 'read' then the
  *   iwl->rxq is replenished and the READ INDEX is updated (updating the
  *   'processed' and 'read' driver indexes as well)
@@ -4037,12 +4037,12 @@ int iwl_rx_queue_restock(struct iwl_priv *priv)
 }
 
 /**
- * iwl_rx_replensih - Move all used packet from rx_used to rx_free
+ * iwl_rx_replenish - Move all used packet from rx_used to rx_free
  *
  * When moving to rx_free an SKB is allocated for the slot.
  *
  * Also restock the Rx queue via iwl_rx_queue_restock.
- * This is called as a scheduled work item (except for during intialization)
+ * This is called as a scheduled work item (except for during initialization)
  */
 void iwl_rx_replenish(void *data)
 {
@@ -6027,7 +6027,7 @@ static int iwl_set_ucode_ptrs(struct iwl_priv *priv)
 }
 
 /**
- * iwl_init_alive_start - Called after REPLY_ALIVE notification receieved
+ * iwl_init_alive_start - Called after REPLY_ALIVE notification received
  *
  * Called after REPLY_ALIVE notification received from "initialize" uCode.
  *
@@ -6670,7 +6670,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	return;
 
  done:
-	/* inform mac80211 sacn aborted */
+	/* inform mac80211 scan aborted */
 	queue_work(priv->workqueue, &priv->scan_completed);
 	mutex_unlock(&priv->mutex);
 }
@@ -6952,7 +6952,7 @@ static int iwl_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 	}
 
 	/* TODO: Figure out how to get ieee80211_local->sta_scanning w/ only
-	 * what is exposed through include/ declrations */
+	 * what is exposed through include/ declarations */
 	if (unlikely(!iwl_param_disable_hw_scan &&
 		     test_bit(STATUS_SCANNING, &priv->status))) {
 		IWL_DEBUG_MAC80211("leave - scanning\n");
@@ -8470,7 +8470,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	mutex_unlock(&priv->mutex);
 
-	IWL_DEBUG_INFO("Queing UP work.\n");
+	IWL_DEBUG_INFO("Queueing UP work.\n");
 
 	queue_work(priv->workqueue, &priv->up);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 90561bb..850ba1f 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -286,7 +286,7 @@ static int iwl_tx_queue_alloc(struct iwl_priv *priv,
 		txq->txb = kmalloc(sizeof(txq->txb[0]) *
 				   TFD_QUEUE_SIZE_MAX, GFP_KERNEL);
 		if (!txq->txb) {
-			IWL_ERROR("kmalloc for auxilary BD "
+			IWL_ERROR("kmalloc for auxiliary BD "
 				  "structures failed\n");
 			goto error;
 		}
@@ -322,7 +322,7 @@ int iwl_tx_queue_init(struct iwl_priv *priv,
 	int len;
 	int rc = 0;
 
-	/* alocate command space + one big command for scan since scan
+	/* allocate command space + one big command for scan since scan
 	 * command is very huge the system will not have two scan at the
 	 * same time */
 	len = sizeof(struct iwl_cmd) * slots_num;
@@ -405,7 +405,7 @@ const u8 BROADCAST_ADDR[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
 /**************************************************************/
 
-#if 0 /* temparary disable till we add real remove station */
+#if 0 /* temporary disable till we add real remove station */
 static u8 iwl_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 {
 	int index = IWL_INVALID_STATION;
@@ -481,7 +481,7 @@ u8 iwl_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap, u8 flags)
 		}
 
 
-	/* These twh conditions has the same outcome but keep them separate
+	/* These two conditions has the same outcome but keep them separate
 	  since they have different meaning */
 	if (unlikely(index == IWL_INVALID_STATION)) {
 		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
@@ -969,7 +969,7 @@ static int iwl_check_rxon_cmd(struct iwl_rxon_cmd *rxon)
 
 /**
  * iwl_full_rxon_required - determine if RXON_ASSOC can be used in RXON commit
- * @priv: staging_rxon is comapred to active_rxon
+ * @priv: staging_rxon is compared to active_rxon
  *
  * If the RXON structure is changing sufficient to require a new
  * tune or to clear and reset the RXON_FILTER_ASSOC_MSK then return 1
@@ -1072,7 +1072,7 @@ static int iwl_send_rxon_assoc(struct iwl_priv *priv)
 /**
  * iwl_commit_rxon - commit staging_rxon to hardware
  *
- * The RXON command in staging_rxon is commited to the hardware and
+ * The RXON command in staging_rxon is committed to the hardware and
  * the active_rxon structure is updated with the new data.  This
  * function correctly transitions out of the RXON_ASSOC_MSK state if
  * a HW tune is required based on the RXON structure changes.
@@ -2222,7 +2222,7 @@ static int iwl_send_power_mode(struct iwl_priv *priv, u32 mode)
 	struct iwl_powertable_cmd cmd;
 
 	/* If on battery, set to 3,
-	 * if plugged into AC power, set to CAM ("continuosly aware mode"),
+	 * if plugged into AC power, set to CAM ("continuously aware mode"),
 	 * else user level */
 	switch (mode) {
 	case IWL_POWER_BATTERY:
@@ -2514,7 +2514,7 @@ static void iwl_set_flags_for_phymode(struct iwl_priv *priv, u8 phymode)
 }
 
 /*
- * initilize rxon structure with default values fromm eeprom
+ * initialize rxon structure with default values from eeprom
  */
 static void iwl_connection_init_rx_config(struct iwl_priv *priv)
 {
@@ -2784,7 +2784,7 @@ static int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 		return priv->hw_setting.bcast_sta_id;
 
 	default:
-		IWL_WARNING("Unkown mode of operation: %d", priv->iw_mode);
+		IWL_WARNING("Unknown mode of operation: %d", priv->iw_mode);
 		return priv->hw_setting.bcast_sta_id;
 	}
 }
@@ -4201,7 +4201,7 @@ static void iwl_tx_cmd_complete(struct iwl_priv *priv,
  * The management in the driver is as follows:
  * + A list of pre-allocated SKBs is stored in iwl->rxq->rx_free.  When
  *   iwl->rxq->free_count drops to or below RX_LOW_WATERMARK, work is scheduled
- *   to replensish the iwl->rxq->rx_free.
+ *   to replenish the iwl->rxq->rx_free.
  * + In iwl_rx_replenish (scheduled) if 'processed' != 'read' then the
  *   iwl->rxq is replenished and the READ INDEX is updated (updating the
  *   'processed' and 'read' driver indexes as well)
@@ -4359,12 +4359,12 @@ int iwl_rx_queue_restock(struct iwl_priv *priv)
 }
 
 /**
- * iwl_rx_replensih - Move all used packet from rx_used to rx_free
+ * iwl_rx_replenish - Move all used packet from rx_used to rx_free
  *
  * When moving to rx_free an SKB is allocated for the slot.
  *
  * Also restock the Rx queue via iwl_rx_queue_restock.
- * This is called as a scheduled work item (except for during intialization)
+ * This is called as a scheduled work item (except for during initialization)
  */
 void iwl_rx_replenish(void *data)
 {
@@ -6400,7 +6400,7 @@ static int iwl_set_ucode_ptrs(struct iwl_priv *priv)
 }
 
 /**
- * iwl_init_alive_start - Called after REPLY_ALIVE notification receieved
+ * iwl_init_alive_start - Called after REPLY_ALIVE notification received
  *
  * Called after REPLY_ALIVE notification received from "initialize" uCode.
  *
@@ -7045,7 +7045,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	return;
 
  done:
-	/* inform mac80211 sacn aborted */
+	/* inform mac80211 scan aborted */
 	queue_work(priv->workqueue, &priv->scan_completed);
 	mutex_unlock(&priv->mutex);
 }
@@ -7342,7 +7342,7 @@ static int iwl_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 	}
 
 	/* TODO: Figure out how to get ieee80211_local->sta_scanning w/ only
-	 * what is exposed through include/ declrations */
+	 * what is exposed through include/ declarations */
 	if (unlikely(!iwl_param_disable_hw_scan &&
 		     test_bit(STATUS_SCANNING, &priv->status))) {
 		IWL_DEBUG_MAC80211("leave - scanning\n");
@@ -9066,7 +9066,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	mutex_unlock(&priv->mutex);
 
-	IWL_DEBUG_INFO("Queing UP work.\n");
+	IWL_DEBUG_INFO("Queueing UP work.\n");
 
 	queue_work(priv->workqueue, &priv->up);
 
diff --git a/drivers/net/wireless/iwlwifi/iwlwifi.h b/drivers/net/wireless/iwlwifi/iwlwifi.h
index 432ce88..8e52fef 100644
--- a/drivers/net/wireless/iwlwifi/iwlwifi.h
+++ b/drivers/net/wireless/iwlwifi/iwlwifi.h
@@ -54,9 +54,9 @@ extern struct pci_device_id iwl_hw_card_ids[];
  * Driver implementation data structures, constants, inline
  * functions
  *
- * NOTE:  DO NOT PUT HARDWARE/UCODE SPECIFIC DECLRATIONS HERE
+ * NOTE:  DO NOT PUT HARDWARE/UCODE SPECIFIC DECLARATIONS HERE
  *
- * Hardware specific declrations go into iwl-*hw.h
+ * Hardware specific declarations go into iwl-*hw.h
  *
  */
 
@@ -467,7 +467,7 @@ union iwl_qos_capabity {
 	u8 val;
 };
 
-/* QoS sturctures */
+/* QoS structures */
 struct iwl_qos_info {
 	int qos_enable;
 	int qos_active;
-- 
1.5.2
