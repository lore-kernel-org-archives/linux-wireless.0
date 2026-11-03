Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793718553;
	b=ple5tigbyr+0vk5Jzy0BRBe3RltyBY5m15Tp+qumELWBP55BD6bUqpdEifU2aLVi4GzU
	 sX992AukLc7i9xPRN7gKISHT26Mp2sxcLjpndXPRGA4j71e936CtT4NELmanTKY5VHcmO
	 gv3lHb0MtcXL1FXOGRagJtf8h6xA4IXGAASWm3yhsSZX/2C9+qXrWJNxTU4jf5D6EinVX
	 sAJZGvRSxYz+OoIJo1oBaQUJBuz7Tg4jZN6/4mYigRQ7dmAxM4YVoDOS5nc3/2oEN1n7K
	 ZQi5RIoX7jMca0cA/j2NJepR7hIz1wTD0aXSXe43Wt1BFcoeMGAtM6AEREAarei9UTA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718553;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 MIME-Version:Date:X-ZohoMailClient;
	bh=kuKUTzuQIaW4jbmuRZtJ+2L+4GPicM6j7R4LLmFYIQA=;
	b=0WqNggOicprFhA8mmSdc4Ycs1lxk/1OjRi16Fwa71xO/FpIL7YRtIevRu1HgNWTIE6iL
	 aFTNpzVWAV8EdIPedUusOajaq4Ovz2ooFMu4ng3q4ps33B0Bt/U2aiD6L4EDgAue5IT7K
	 qXVFd0/dw8t2j6wLZk1ilLo2jtexY25t/DCioJJXBSJF/dwR0gX41Rdj4VyZPAq1yYHk3
	 JjPEQr2wQHkvM3xsWHAiU7EuspayJiA3nKiM3D5QwHry47q1FBZ64LVhC2Ylcz/vfO8la
	 ska62auFs2/vlASjBFB9KKYAHSNgJUMJz5r50kdrA/LQGRFtwzBrw73DhcgJqxACp1A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ph4ntom-rev.uz;
	spf=pass smtp.mailfrom=ph4ntom-rev.uz;
	dkim=pass header.d=ph4ntom-rev.uz header.i=@ph4ntom-rev.uz header.a=rsa-sha256 header.s=zoho header.b=qs7qcw4+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.54
Received: from sender5-of-o54.zoho.com (sender5-of-o54.zoho.com [165.173.182.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36F8606BA03;
	Tue,  3 Nov 2026 15:09:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B36F8606BA03
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ph4ntom-rev.uz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ph4ntom-rev.uz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ph4ntom-rev.uz header.i=@ph4ntom-rev.uz header.a=rsa-sha256 header.s=zoho header.b=qs7qcw4+
ARC-Seal: i=1; a=rsa-sha256; t=1793718505; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=mQ2bASpubzjV2BlT8yXTh7A6D+fSzkfKGkXrlLLWtRJS7cKeJhCyBzSQYU926YOQ0U8lk9qTaUH3hm2Lv71ysKgT1EGY5RQoDd9UeH5dd01ys0L2bNfJa+tJChoB0jX32FVHSyuMZWTSzOmegep6eW/TuzHWpNe57NXLi1qecMw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1793718505; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=kuKUTzuQIaW4jbmuRZtJ+2L+4GPicM6j7R4LLmFYIQA=; 
	b=j7lmvA/0jol834F34IM2b6Hpv96ReiMau4vqAaU5vigTTUyrYZrUU0L+a0HyGlC3dWhNe30GNVZovpqQH8N0NGx3CEplgjyl28urux2gamCpW6mSjzodNzK1Gm91cReNtKHD0mqmGPjR0nVZc5r87MPNVfh0K/SiXzKStE24qU8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=ph4ntom-rev.uz;
	spf=pass  smtp.mailfrom=owner@ph4ntom-rev.uz;
	dmarc=pass header.from=<owner@ph4ntom-rev.uz>
DKIM-Signature: a=rsa-sha256; b=qs7qcw4+/fxw771Wd2F8cvaasQi2W0P1ER5aAlkWrWo5dhsZMvceyz8yJyU01PUXFK5IHEHL9K617TcgSX7jidyKW7XV/3FlYeeWaMBXUx3ozR2VaG1zTqGlFHRZMF5UbQLt1C6rPD8U2I/2zZ9+MBVjWm3OTgAHBYLuS54+X10vxfJgPLcwzhMbOaxtUY3Lhf25kE+1cRldNj9iGPleGXb4hH6/RMQqE5lhmEOki6uYwrA5IAZWUf+BLvWHMflI9Mml9TZnRG54jZxT7Le0pJviR93RxMORzG2zPtHllbsNT5hljazqxoksExewVYe1mkWCO1bz7WvABzxP95GVJA==; c=relaxed/relaxed; s=zoho; d=ph4ntom-rev.uz; v=1; bh=kuKUTzuQIaW4jbmuRZtJ+2L+4GPicM6j7R4LLmFYIQA=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 17937185046021016.8980529861477;
	Tue, 3 Nov 2026 07:08:24 -0800 (PST)
Message-ID: <179371849554.20972.4737532522625772373@ph4ntom-rev.uz>
From: ph4ntom-rev <owner@ph4ntom-rev.uz>
To: pkshih@realtek.com, linux-wireless@vger.kernel.org
Cc: kvalo@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] wifi: rtw89: support raw frame injection on standalone
 monitor interface
In-Reply-To: <179371849554.20972.16232816164394690660@ph4ntom-rev.uz>
References: <1a196d6dfbc.35537d221913104450.3720060455831933789@zoho.com>
 <b41e89b40fc640879b9d71b86311f900@realtek.com>
 <1a19b7cce82.5dc2e93-44860545.1830508576953059669@zoho.com>
 <179371849554.20972.16232816164394690660@ph4ntom-rev.uz>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Tue, 3 Nov 2026 07:08:24 -0800 (PST)
X-ZohoMailClient: External

When injecting raw 802.11 Radiotap frames into a standalone monitor
interface (NL80211_IFTYPE_MONITOR brought up via 'iw set type monitor'),
net/mac80211/tx.c (ieee80211_monitor_start_xmit) transmits the frame
without an operational station context, passing info->control.vif =3D NULL.
Evaluating vif_to_rtwvif(vif) unconditionally in rtw89_ops_tx() triggers
a kernel NULL pointer dereference OOPS.

Furthermore, on hardware scheduler execution:
1. In rtw89_core_tx_update_injection(), handle rates[0].idx < 0 (omitted
   bitrate in Radiotap) by changing idx to signed s8, falling back to
   OFDM 6 Mbps (RTW89_HW_RATE_OFDM6) with use_rate and dis_data_fb set,
   and bounding retries when IEEE80211_TX_CTL_NO_ACK is set. Always enable
   en_wd_info for injected frames so txwd_info is built into the
   descriptor.
2. In rtw89_vif_type_mapping(), configure NL80211_IFTYPE_MONITOR with
   RTW89_NET_TYPE_NO_LINK and RTW89_SELF_ROLE_AP.
   In rtw89_ops_add_interface(), initialize default CMAC/DMAC tables via
   rtw89_chip_h2c_default_*mac_tbl, issue rtw89_fw_h2c_join_info(), and
   unpause the MACID via rtw89_mac_unpause_macid() across all 4 MACID
   sleep banks.
3. Protect pure_monitor_mode_vif with RCU: annotate with __rcu in core.h,
   guard rtw89_ops_tx() with rcu_read_lock(), and place rcu_assign_pointer
   and synchronize_rcu() at the very top of rtw89_ops_remove_interface()
   prior to teardown of links, CAM, and MACID resources to completely
   prevent Use-After-Free conditions. Disassociate firmware join state
   via rtw89_fw_h2c_join_info(..., true) on interface removal, and clear
   pure_monitor_mode_vif if a non-monitor interface is added.

Signed-off-by: ph4ntom-rev <owner@ph4ntom-rev.uz>
---
v1 -> v2:
 - Use struct rtw89_vif_link * in rtw89_chip_h2c_default_*mac_tbl() and
   rtw89_fw_h2c_join_info() to match modern MLO link abstractions.
 - Protect pure_monitor_mode_vif with RCU, wrap TX path in rcu_read_lock(),
   and use rtwvif_to_vif() helper instead of nonexistent struct member.
 - In rtw89_ops_remove_interface(), move rcu_assign_pointer(..., NULL) and
   synchronize_rcu() to the very top to prevent Use-After-Free during teardow=
n.
 - Issue rtw89_fw_h2c_join_info(..., true) on monitor interface removal to
   cleanly disassociate firmware state.
 - Reset pure_monitor_mode_vif if another non-monitor interface is added.
 - Encapsulate sleep mask unpausing into rtw89_mac_unpause_macid() in mac.c
   covering all 4 register banks (R_AX_MACID_SLEEP_0..3) guarded by
   RTW89_CHIP_AX.
 - Use lockdep_assert_wiphy and rcu_dereference_protected() in
   rtw89_chip_rfk_channel_for_pure_mon_vif() to avoid context switch
   warnings in sleeping RF calibration routines.
 - Change rate index type to signed s8 in rtw89_core_tx_update_injection(),
   fall back to OFDM 6 Mbps, and enable en_wd_info for descriptor building.
 drivers/net/wireless/realtek/rtw89/core.c     | 24 ++++++++++--
 drivers/net/wireless/realtek/rtw89/core.h     |  2 +-
 drivers/net/wireless/realtek/rtw89/mac.c      | 11 ++++++
 drivers/net/wireless/realtek/rtw89/mac.h      |  1 +
 drivers/net/wireless/realtek/rtw89/mac80211.c | 39 +++++++++++++++++--
 5 files changed, 69 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless=
/realtek/rtw89/core.c
index 486c177..af31b94 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -474,7 +474,7 @@ void rtw89_chip_rfk_channel(struct rtw89_dev *rtwdev,
 			    struct rtw89_vif_link *rtwvif_link)
 {
 	const struct rtw89_chip_info *chip =3D rtwdev->chip;
-	bool mon =3D !!rtwdev->pure_monitor_mode_vif;
+	bool mon =3D !!rcu_access_pointer(rtwdev->pure_monitor_mode_vif);
 	bool prehdl_link =3D false;
=20
 	if (chip->chip_gen !=3D RTW89_CHIP_AX &&
@@ -499,9 +499,13 @@ void rtw89_chip_rfk_channel(struct rtw89_dev *rtwdev,
 static void rtw89_chip_rfk_channel_for_pure_mon_vif(struct rtw89_dev *rtwdev,
 						    enum rtw89_phy_idx phy_idx)
 {
-	struct rtw89_vif *rtwvif =3D rtwdev->pure_monitor_mode_vif;
+	struct rtw89_vif *rtwvif;
 	struct rtw89_vif_link *rtwvif_link;
=20
+	lockdep_assert_wiphy(rtwdev->hw->wiphy);
+
+	rtwvif =3D rcu_dereference_protected(rtwdev->pure_monitor_mode_vif,
+					   lockdep_is_held(&rtwdev->hw->wiphy->mtx));
 	if (!rtwvif)
 		return;
=20
@@ -1171,9 +1175,21 @@ static void rtw89_core_tx_update_injection(struct rtw8=
9_dev *rtwdev,
 	enum mac80211_rate_control_flags flags =3D info->control.rates[0].flags;
 	struct rtw89_tx_desc_info *desc_info =3D &tx_req->desc_info;
 	const struct rtw89_chan *chan;
-	u8 idx =3D info->control.rates[0].idx;
+	s8 idx =3D info->control.rates[0].idx;
 	u8 nss, mcs;
=20
+	desc_info->en_wd_info =3D true;
+	if (idx < 0) {
+		desc_info->data_rate =3D RTW89_HW_RATE_OFDM6;
+		desc_info->use_rate =3D true;
+		desc_info->dis_data_fb =3D true;
+		if (info->flags & IEEE80211_TX_CTL_NO_ACK) {
+			desc_info->tx_cnt_lmt_en =3D true;
+			desc_info->tx_cnt_lmt =3D 1;
+		}
+		return;
+	}
+
 	desc_info->use_rate =3D true;
 	desc_info->dis_data_fb =3D true;
=20
@@ -5006,6 +5022,8 @@ void rtw89_vif_type_mapping(struct rtw89_vif_link *rtwv=
if_link, bool assoc)
 		rtwvif_link->addr_cam.sec_ent_mode =3D RTW89_ADDR_CAM_SEC_NORMAL;
 		break;
 	case NL80211_IFTYPE_MONITOR:
+		rtwvif_link->net_type =3D RTW89_NET_TYPE_NO_LINK;
+		rtwvif_link->self_role =3D RTW89_SELF_ROLE_AP;
 		break;
 	default:
 		WARN_ON(1);
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless=
/realtek/rtw89/core.h
index 05adf20..e844138 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -6318,7 +6318,7 @@ struct rtw89_dev {
 	int napi_budget_countdown;
=20
 	struct rtw89_debugfs *debugfs;
-	struct rtw89_vif *pure_monitor_mode_vif;
+	struct rtw89_vif __rcu *pure_monitor_mode_vif;
=20
 	/* HCI related data, keep last */
 	u8 priv[] __aligned(sizeof(void *));
diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/=
realtek/rtw89/mac.c
index 54aad37..58b0fe0 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -6240,6 +6240,17 @@ void rtw89_mac_flush_txq(struct rtw89_dev *rtwdev, u32=
 queues, bool drop)
 		rtw89_info(rtwdev, "timed out to flush queues\n");
 }
=20
+void rtw89_mac_unpause_macid(struct rtw89_dev *rtwdev, u8 mac_id)
+{
+	u8 grp =3D mac_id >> 5;
+	u8 shift =3D mac_id & 0x1f;
+
+	rtw89_fw_h2c_macid_pause(rtwdev, shift, grp, false);
+
+	if (rtwdev->chip->chip_gen =3D=3D RTW89_CHIP_AX && grp < 4)
+		rtw89_write32_clr(rtwdev, R_AX_MACID_SLEEP_0 + grp * 4, BIT(shift));
+}
+
 int rtw89_mac_coex_init(struct rtw89_dev *rtwdev, const struct rtw89_mac_ax_=
coex *coex)
 {
 	enum rtw89_core_chip_id chip_id =3D rtwdev->chip->chip_id;
diff --git a/drivers/net/wireless/realtek/rtw89/mac.h b/drivers/net/wireless/=
realtek/rtw89/mac.h
index 9db9ae2..587bcb6 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.h
+++ b/drivers/net/wireless/realtek/rtw89/mac.h
@@ -1432,6 +1432,7 @@ void rtw89_mac_set_edcca_mode_bands(struct rtw89_dev *r=
twdev, bool normal)
 void rtw89_mac_set_rx_fltr(struct rtw89_dev *rtwdev, u8 mac_idx, u32 rx_fltr=
);
 void rtw89_mac_update_rts_threshold(struct rtw89_dev *rtwdev);
 void rtw89_mac_flush_txq(struct rtw89_dev *rtwdev, u32 queues, bool drop);
+void rtw89_mac_unpause_macid(struct rtw89_dev *rtwdev, u8 mac_id);
 int rtw89_mac_coex_init(struct rtw89_dev *rtwdev, const struct rtw89_mac_ax_=
coex *coex);
 int rtw89_mac_coex_init_v1(struct rtw89_dev *rtwdev,
 			   const struct rtw89_mac_ax_coex *coex);
diff --git a/drivers/net/wireless/realtek/rtw89/mac80211.c b/drivers/net/wire=
less/realtek/rtw89/mac80211.c
index 33a6598..3baa627 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -23,16 +23,30 @@ static void rtw89_ops_tx(struct ieee80211_hw *hw,
 	struct rtw89_dev *rtwdev =3D hw->priv;
 	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
 	struct ieee80211_vif *vif =3D info->control.vif;
-	struct rtw89_vif *rtwvif =3D vif_to_rtwvif(vif);
+	struct rtw89_vif *rtwvif;
 	struct ieee80211_sta *sta =3D control->sta;
 	u32 flags =3D IEEE80211_SKB_CB(skb)->flags;
 	int ret, qsel;
=20
+	rcu_read_lock();
+	if (!vif) {
+		rtwvif =3D rcu_dereference(rtwdev->pure_monitor_mode_vif);
+		if (!rtwvif) {
+			rcu_read_unlock();
+			ieee80211_free_txskb(hw, skb);
+			return;
+		}
+		vif =3D rtwvif_to_vif(rtwvif);
+	} else {
+		rtwvif =3D vif_to_rtwvif(vif);
+	}
+
 	if (rtwvif->offchan && !(flags & IEEE80211_TX_CTL_TX_OFFCHAN) && sta) {
 		struct rtw89_sta *rtwsta =3D sta_to_rtwsta(sta);
=20
 		rtw89_debug(rtwdev, RTW89_DBG_TXRX, "ops_tx during offchan\n");
 		skb_queue_tail(&rtwsta->roc_queue, skb);
+		rcu_read_unlock();
 		return;
 	}
=20
@@ -40,9 +54,11 @@ static void rtw89_ops_tx(struct ieee80211_hw *hw,
 	if (ret) {
 		rtw89_err(rtwdev, "failed to transmit skb: %d\n", ret);
 		ieee80211_free_txskb(hw, skb);
+		rcu_read_unlock();
 		return;
 	}
 	rtw89_core_tx_kick_off(rtwdev, qsel);
+	rcu_read_unlock();
 }
=20
 static void rtw89_ops_wake_tx_queue(struct ieee80211_hw *hw,
@@ -221,8 +237,16 @@ static int rtw89_ops_add_interface(struct ieee80211_hw *=
hw,
 	if (ret)
 		goto unset_link;
=20
-	rtwdev->pure_monitor_mode_vif =3D vif->type =3D=3D NL80211_IFTYPE_MONITOR ?
-					rtwvif : NULL;
+	if (vif->type =3D=3D NL80211_IFTYPE_MONITOR) {
+		rtw89_chip_h2c_default_cmac_tbl(rtwdev, rtwvif_link, NULL);
+		rtw89_chip_h2c_default_dmac_tbl(rtwdev, rtwvif_link, NULL);
+		rtw89_fw_h2c_join_info(rtwdev, rtwvif_link, NULL, false);
+		rtw89_mac_unpause_macid(rtwdev, rtwvif_link->mac_id);
+		rcu_assign_pointer(rtwdev->pure_monitor_mode_vif, rtwvif);
+	} else if (rcu_access_pointer(rtwdev->pure_monitor_mode_vif)) {
+		rcu_assign_pointer(rtwdev->pure_monitor_mode_vif, NULL);
+		synchronize_rcu();
+	}
 	rtw89_recalc_lps(rtwdev);
 	return 0;
=20
@@ -248,6 +272,11 @@ static void rtw89_ops_remove_interface(struct ieee80211_=
hw *hw,
=20
 	lockdep_assert_wiphy(hw->wiphy);
=20
+	if (vif->type =3D=3D NL80211_IFTYPE_MONITOR) {
+		rcu_assign_pointer(rtwdev->pure_monitor_mode_vif, NULL);
+		synchronize_rcu();
+	}
+
 	rtw89_debug(rtwdev, RTW89_DBG_STATE, "remove vif %pM type %d p2p %d\n",
 		    vif->addr, vif->type, vif->p2p);
=20
@@ -261,6 +290,9 @@ static void rtw89_ops_remove_interface(struct ieee80211_h=
w *hw,
 		goto bottom;
 	}
=20
+	if (vif->type =3D=3D NL80211_IFTYPE_MONITOR)
+		rtw89_fw_h2c_join_info(rtwdev, rtwvif_link, NULL, true);
+
 	__rtw89_ops_remove_iface_link(rtwdev, rtwvif_link);
=20
 	rtw89_vif_unset_link(rtwvif, RTW89_VIF_IDLE_LINK_ID);
@@ -270,7 +302,6 @@ bottom:
 	rtw89_core_release_bit_map(rtwdev->hw_port, port);
 	rtw89_release_mac_id(rtwdev, macid);
=20
-	rtwdev->pure_monitor_mode_vif =3D NULL;
=20
 	rtw89_recalc_lps(rtwdev);
 	rtw89_enter_ips_by_hwflags(rtwdev);
--=20
2.53.0
