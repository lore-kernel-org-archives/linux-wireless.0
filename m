Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793824295;
	b=Pw6DQPkjzE1cCWuCkNeKRwYkq1xVoQZwH46BiVSxXljnaK/YCVRO0F7DlNkC+6UmeUrp
	 gkln/tCBJ0HUao/zDiTvrx8UXNryvP4Nr4J3MiV2Ar/A3SHov0tk3J/Lg9ggyY5v/6bpL
	 3fXTnVZESrcqIUA8o22F3ixpLhb0J//1MBDD5CKUehMq3tmd4ZMQyyOUwLySpV2hoZGh5
	 nnhgA95GbgMuPWuvofTOma0Md0vpGDbSGbVq6y5qu/ykrr7IU79K9Is6qFMIWNzFotwXQ
	 +eVn1O2Zk3Z4RorqIs0sE27ZN/0Aswp+Y8I5LqbzWiek8Vayek0EjHHPQOrSzCRAvww==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793824295;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-ZohoMailClient;
	bh=yRCgNc0yJCSZ/5WOdRB8K1ro4gNyIQLhYezVDHo99AE=;
	b=vGGpiuG1xk5WH/XPsUBNVI+YBnaswsN7FZJ38AAWAypIiKWpYlVbh5OMQAuhmUGZulyw
	 cwLZRUs+SSfJI7g9RHzbudQQdhE1Ulu+WWRre6NdXDbvS55KuWmOoH0WO4/NI1I5N1UBS
	 IUOMQIi3bNV3MxxzPe4scwNigTViSfOcdDUnNkjV3IG8ItrqQVKT3Pg7wzQxBWAnQIATs
	 iiNOITpot0R44F7afbNNuSxZbmb5Mu5xgXe5/q+UdGx/QoIhGSMseUHj6CDVTIMQnEjuE
	 NyAFpJPpv0MBQe4Lg7fbuZjVeZ9nlN6yF2pKaphCXk/FTGncx5reLOwS2lBuPrWKy6Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ph4ntom-rev.uz;
	spf=pass smtp.mailfrom=ph4ntom-rev.uz;
	dkim=pass header.d=ph4ntom-rev.uz header.i=@ph4ntom-rev.uz header.a=rsa-sha256 header.s=zoho header.b="Zi/kEvJd";
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.54
Received: from sender6-of-o54.zoho.com (sender6-of-o54.zoho.com [165.173.180.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9C46082BFE;
	Wed,  4 Nov 2026 20:31:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E9C46082BFE
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ph4ntom-rev.uz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ph4ntom-rev.uz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ph4ntom-rev.uz header.i=@ph4ntom-rev.uz header.a=rsa-sha256 header.s=zoho header.b=Zi/kEvJd
ARC-Seal: i=1; a=rsa-sha256; t=1793824264; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=kFcIdntCtk+5fu+MxJDtDHT+YgIQXRecDvjW20GeiEdVw6IHPENDuwwBsGRNhcFQLDREWlaw+zo+uuvAez6dKmj5wv2wwZRMlqfyqOe3cN2uMXN6415kbcNRlpCVuyy/PbarsgbF/hioJnu7kKMC//8btUznHTnXyhRENFJPsHY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1793824264; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=yRCgNc0yJCSZ/5WOdRB8K1ro4gNyIQLhYezVDHo99AE=; 
	b=Q2/TxIRbt2KAXQooIdEDd2xBB1i6WlDzxfviCzdvVbMVYYnBprTP6d8a21xJDztByZMJFDwMDSUN3rYVbhZbvDs6Ek88W0YLqG7R5hS3Lz204Lj5z0dQZAv3mTwL38+ab9p8l2pobZvJmCaydrY6YtxCQ9JIhQZMrvKJjVNBE9o=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=ph4ntom-rev.uz;
	spf=pass  smtp.mailfrom=owner@ph4ntom-rev.uz;
	dmarc=pass header.from=<owner@ph4ntom-rev.uz>
DKIM-Signature: a=rsa-sha256; b=Zi/kEvJdYFlO5A2mSzRfSFBIPRaSMWxfmiDV0tO3og+7KVoSBPiZXpzWUpkrNyqKb2BoQyvPwCgQL4nykULh+rYkdAK6aFboZIASJSQ1+iyzzLWZkVrzurRet7RYTubVakRDkE61fBNZBftn6nVuUzBOjRKnq+3vzPqmC+pW0Kf2uSCM6Y7jeyAfRCoXt8Bji4MSsPTC2zHrUy77+ojDfUXmC5/5kfLnOLTi4cOSI0xjumUtPbQfyk/hoLcqIeP5scUesbKjVvmb2OTUVfw3c52OqifEZ9D2bzcPDQ1Y1/zKz6Kd1z4VXYF5Wp0WlwWLrVFCbIXIOvwhZyMpsn5Z/w==; c=relaxed/relaxed; s=zoho; d=ph4ntom-rev.uz; v=1; bh=yRCgNc0yJCSZ/5WOdRB8K1ro4gNyIQLhYezVDHo99AE=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 1793824263222403.67571711069684;
	Wed, 4 Nov 2026 12:31:03 -0800 (PST)
From: Enver <owner@ph4ntom-rev.uz>
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com,
	kvalo@kernel.org,
	linux-kernel@vger.kernel.org,
	ph4ntom-rev <owner@ph4ntom-rev.uz>
Subject: [PATCH v3 2/3] wifi: rtw89: support raw frame injection on standalone monitor interface
Date: Thu,  5 Nov 2026 01:30:50 +0500
Message-ID: <20261104203051.564-3-owner@ph4ntom-rev.uz>
X-Mailer: git-send-email 2.56.0.windows.4
In-Reply-To: <20261104203051.564-1-owner@ph4ntom-rev.uz>
References: <20261104203051.564-1-owner@ph4ntom-rev.uz>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

From: ph4ntom-rev <owner@ph4ntom-rev.uz>

Radiotap injection on a standalone monitor interface can pass
a NULL info->control.vif. Resolve the monitor VIF under RCU
instead of dereferencing the NULL pointer, and synchronize with
interface teardown.

Configure the monitor link role, mark it connected to the
firmware scheduler and disconnect it during removal. Check the
firmware command result when adding an interface and roll back
the link on failure.

Handle an unspecified injected rate by selecting OFDM 6 Mbps
and limiting retries for NO_ACK frames. Protect monitor VIF
accesses during RF calibration with RCU and the wiphy lock.

Signed-off-by: ph4ntom-rev <owner@ph4ntom-rev.uz>
---
 drivers/net/wireless/realtek/rtw89/core.c     | 24 ++++++++--
 drivers/net/wireless/realtek/rtw89/core.h     |  2 +-
 drivers/net/wireless/realtek/rtw89/mac80211.c | 45 ++++++++++++++++---
 3 files changed, 62 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 58ee5efc3..55e626438 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -530,7 +530,7 @@ void rtw89_chip_rfk_channel(struct rtw89_dev *rtwdev,
 			    struct rtw89_vif_link *rtwvif_link)
 {
 	const struct rtw89_chip_info *chip = rtwdev->chip;
-	bool mon = !!rtwdev->pure_monitor_mode_vif;
+	bool mon = !!rcu_access_pointer(rtwdev->pure_monitor_mode_vif);
 	bool prehdl_link = false;
 
 	if (chip->chip_gen != RTW89_CHIP_AX &&
@@ -560,9 +560,13 @@ void rtw89_chip_rfk_channel(struct rtw89_dev *rtwdev,
 static void rtw89_chip_rfk_channel_for_pure_mon_vif(struct rtw89_dev *rtwdev,
 						    enum rtw89_phy_idx phy_idx)
 {
-	struct rtw89_vif *rtwvif = rtwdev->pure_monitor_mode_vif;
+	struct rtw89_vif *rtwvif;
 	struct rtw89_vif_link *rtwvif_link;
 
+	lockdep_assert_wiphy(rtwdev->hw->wiphy);
+
+	rtwvif = rcu_dereference_protected(rtwdev->pure_monitor_mode_vif,
+					   lockdep_is_held(&rtwdev->hw->wiphy->mtx));
 	if (!rtwvif)
 		return;
 
@@ -1239,9 +1243,21 @@ static void rtw89_core_tx_update_injection(struct rtw89_dev *rtwdev,
 	enum mac80211_rate_control_flags flags = info->control.rates[0].flags;
 	struct rtw89_tx_desc_info *desc_info = &tx_req->desc_info;
 	const struct rtw89_chan *chan;
-	u8 idx = info->control.rates[0].idx;
+	s8 idx = info->control.rates[0].idx;
 	u8 nss, mcs;
 
+	if (info->flags & IEEE80211_TX_CTL_NO_ACK) {
+		desc_info->tx_cnt_lmt_en = true;
+		desc_info->tx_cnt_lmt = 1;
+	}
+
+	if (idx < 0) {
+		desc_info->data_rate = RTW89_HW_RATE_OFDM6;
+		desc_info->use_rate = true;
+		desc_info->dis_data_fb = true;
+		return;
+	}
+
 	desc_info->use_rate = true;
 	desc_info->dis_data_fb = true;
 
@@ -5726,6 +5742,8 @@ void rtw89_vif_type_mapping(struct rtw89_vif_link *rtwvif_link, bool assoc)
 		rtwvif_link->self_role = RTW89_SELF_ROLE_CLIENT;
 		break;
 	case NL80211_IFTYPE_MONITOR:
+		rtwvif_link->net_type = RTW89_NET_TYPE_NO_LINK;
+		rtwvif_link->self_role = RTW89_SELF_ROLE_AP;
 		break;
 	default:
 		WARN_ON(1);
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 0d893b992..d7f30394c 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -7813,7 +7813,7 @@ struct rtw89_dev {
 	int napi_budget_countdown;
 
 	struct rtw89_debugfs *debugfs;
-	struct rtw89_vif *pure_monitor_mode_vif;
+	struct rtw89_vif __rcu *pure_monitor_mode_vif;
 	struct rtw89_led led;
 
 	/* HCI related data, keep last */
diff --git a/drivers/net/wireless/realtek/rtw89/mac80211.c b/drivers/net/wireless/realtek/rtw89/mac80211.c
index bb6101ccb..5404e031e 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -23,16 +23,30 @@ static void rtw89_ops_tx(struct ieee80211_hw *hw,
 	struct rtw89_dev *rtwdev = hw->priv;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_vif *vif = info->control.vif;
-	struct rtw89_vif *rtwvif = vif_to_rtwvif(vif);
+	struct rtw89_vif *rtwvif;
 	struct ieee80211_sta *sta = control->sta;
 	u32 flags = IEEE80211_SKB_CB(skb)->flags;
 	int ret, qsel;
 
+	rcu_read_lock();
+	if (!vif) {
+		rtwvif = rcu_dereference(rtwdev->pure_monitor_mode_vif);
+		if (!rtwvif) {
+			rcu_read_unlock();
+			ieee80211_free_txskb(hw, skb);
+			return;
+		}
+		vif = rtwvif_to_vif(rtwvif);
+	} else {
+		rtwvif = vif_to_rtwvif(vif);
+	}
+
 	if (rtwvif->offchan && !(flags & IEEE80211_TX_CTL_TX_OFFCHAN) && sta) {
 		struct rtw89_sta *rtwsta = sta_to_rtwsta(sta);
 
 		rtw89_debug(rtwdev, RTW89_DBG_TXRX, "ops_tx during offchan\n");
 		skb_queue_tail(&rtwsta->roc_queue, skb);
+		rcu_read_unlock();
 		return;
 	}
 
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
 
 static void rtw89_ops_wake_tx_queue(struct ieee80211_hw *hw,
@@ -224,11 +240,20 @@ static int rtw89_ops_add_interface(struct ieee80211_hw *hw,
 	if (ret)
 		goto unset_link;
 
-	rtwdev->pure_monitor_mode_vif = vif->type == NL80211_IFTYPE_MONITOR ?
-					rtwvif : NULL;
+	if (vif->type == NL80211_IFTYPE_MONITOR) {
+		ret = rtw89_fw_h2c_join_info(rtwdev, rtwvif_link, NULL, false);
+		if (ret)
+			goto remove_link;
+		rcu_assign_pointer(rtwdev->pure_monitor_mode_vif, rtwvif);
+	} else if (rcu_access_pointer(rtwdev->pure_monitor_mode_vif)) {
+		rcu_assign_pointer(rtwdev->pure_monitor_mode_vif, NULL);
+		synchronize_rcu();
+	}
 	rtw89_recalc_lps(rtwdev);
 	return 0;
 
+remove_link:
+	__rtw89_ops_remove_iface_link(rtwdev, rtwvif_link);
 unset_link:
 	rtw89_vif_unset_link(rtwvif, RTW89_VIF_IDLE_LINK_ID);
 release_port:
@@ -248,9 +273,15 @@ static void rtw89_ops_remove_interface(struct ieee80211_hw *hw,
 	u8 macid = rtw89_vif_get_main_macid(rtwvif);
 	u8 port = rtw89_vif_get_main_port(rtwvif);
 	struct rtw89_vif_link *rtwvif_link;
+	int ret;
 
 	lockdep_assert_wiphy(hw->wiphy);
 
+	if (vif->type == NL80211_IFTYPE_MONITOR) {
+		rcu_assign_pointer(rtwdev->pure_monitor_mode_vif, NULL);
+		synchronize_rcu();
+	}
+
 	rtw89_debug(rtwdev, RTW89_DBG_STATE, "remove vif %pM type %d p2p %d\n",
 		    vif->addr, vif->type, vif->p2p);
 
@@ -264,6 +295,12 @@ static void rtw89_ops_remove_interface(struct ieee80211_hw *hw,
 		goto bottom;
 	}
 
+	if (vif->type == NL80211_IFTYPE_MONITOR) {
+		ret = rtw89_fw_h2c_join_info(rtwdev, rtwvif_link, NULL, true);
+		if (ret)
+			rtw89_warn(rtwdev, "failed to disconnect monitor vif: %d\n", ret);
+	}
+
 	__rtw89_ops_remove_iface_link(rtwdev, rtwvif_link);
 
 	rtw89_vif_unset_link(rtwvif, RTW89_VIF_IDLE_LINK_ID);
@@ -273,8 +310,6 @@ static void rtw89_ops_remove_interface(struct ieee80211_hw *hw,
 	rtw89_core_release_bit_map(rtwdev->hw_port, port);
 	rtw89_release_mac_id(rtwdev, macid);
 
-	rtwdev->pure_monitor_mode_vif = NULL;
-
 	rtw89_recalc_lps(rtwdev);
 	rtw89_enter_ips_by_hwflags(rtwdev);
 }
-- 
2.56.0.windows.4

