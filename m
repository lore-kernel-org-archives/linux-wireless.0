Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793824336;
	b=s56kXZ1I0ZOhexKm8L2KIQbmMt0LmJKSvewelTJnC3qbKKtgLr+N2QGEdWtwTREncjp8
	 av7Pv58XQ4nDKR4A78P/mOjSHvzNN6H+zlDmfydFMR5sVWcsKhRfWJhYd4Q2ypSfnT96w
	 E/yYywnc6zwLMeunE/MbwB7lQMG4Ffvvu0aTLUNzUZba/uXmrkWavBdgtCkVVuxDAMy0B
	 D68ihLuyKLEvrUG8HbW6MinNLQkPpiQ49AhBGhJGYmhO3L2FiP9eCQcl67sAq4P91yseA
	 8EX3F6GN5t3uO95u90wQcVaZDdY0HE5qJ+S/Qyp96JJ1Z5cN/pe143hXfUb5WiYpdng==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793824336;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-ZohoMailClient;
	bh=D8EPv1iZVj0e7JdeDiAc2KXRHYoRaI6ZUJiuMbKDElg=;
	b=VNclHvydQwJMEbjKWH+EmAhLZxPa7qflsBx8ypnTaEJsuzgROoDY4NxQTRweOzJ3OFWU
	 lHNrv8lmHqFxcSnF208QgTc8Vcudq9O8Lie6g8jdF8uUGCXz/ZENIV3LuDfQQTco7hw5H
	 mIx1vJtnXjvVzFyBnHYYKz8Q1RoN977FY/TF4lR5vlqxOgc2PpDBD8nATFp5NVHMoEK9E
	 3gsb/c0cf60M/HWv2bBaeh7akWAMlBrSRpm6lZ1uPUg6Ud3ZN5agX1Z9hh6JgPJFvg394
	 Xj+HqyKnLRNTBTJmyOJknMmMqPWVPNNiOm9dDzpl2patCyaJMgJdnIo1pvHVUIsvHzw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ph4ntom-rev.uz;
	spf=pass smtp.mailfrom=ph4ntom-rev.uz;
	dkim=pass header.d=ph4ntom-rev.uz header.i=@ph4ntom-rev.uz header.a=rsa-sha256 header.s=zoho header.b=u2boLiBe;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.54
Received: from sender5-of-o54.zoho.com (sender5-of-o54.zoho.com [165.173.182.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF18E606A852;
	Wed,  4 Nov 2026 20:32:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF18E606A852
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ph4ntom-rev.uz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ph4ntom-rev.uz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ph4ntom-rev.uz header.i=@ph4ntom-rev.uz header.a=rsa-sha256 header.s=zoho header.b=u2boLiBe
ARC-Seal: i=1; a=rsa-sha256; t=1793824266; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=los6XWqWlSlswbx/xyWJcSkqnA9Kx2xDrcPMPnH/QN9/wqeWKVE3dIdY07llbIRdfHS48t7mH3ZylvvRdeFRO0EWCgyzGbPPm364xc3H/a/0PX+ooAQYmAk8CGGc0L9lD1Z9DJa+idCHkicsLxtZUwGfhTIxAskTStjF+zBCl0s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1793824266; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=D8EPv1iZVj0e7JdeDiAc2KXRHYoRaI6ZUJiuMbKDElg=; 
	b=bjONy6es/OYGFUa5p0g8TI91cj22A2LjnStUnA1gYnom3e7Dm0edC+mKAbsEkE6bNcLiRAUmrHTJKe5okk3D1qLBwOcJHR+BtsmmzW5OT8dQ8IY16YHwwW1zF0Xj1ABU39xP0/CeXMj2OQD5rtR1dI4TPLyxOhg5C/P5LS1nKds=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=ph4ntom-rev.uz;
	spf=pass  smtp.mailfrom=owner@ph4ntom-rev.uz;
	dmarc=pass header.from=<owner@ph4ntom-rev.uz>
DKIM-Signature: a=rsa-sha256; b=u2boLiBeGD/mFMlMok0sflPDIyab4X4BGeSXQssFePqXfaJFN/4WxNCS2fbzWbpjVE2wn3Af6980+hdu0QUVvwcOXKdras3X8TRyXXP29XIRv0PqdfQEVkM+ry1BV5Hoz13jlDQUrzaj7r/U88/AH3dNrfGlDOV3dntnRK7FOiQnxuIT/09po23nNwgEHcFfLV/XEkdL8CRqmc2wT5aQAhh9oyZCvDppASgDfP8AVs/A0BtPtnH8PsqpmRuVG2gdVEaycInG0FjDRsdedtEEV/shgYcn5+gy4igUasj/vjqRrbAW31pIOLW1UtcFkaf0Xo0VLMxOJbrU2dDxLT6hkg==; c=relaxed/relaxed; s=zoho; d=ph4ntom-rev.uz; v=1; bh=D8EPv1iZVj0e7JdeDiAc2KXRHYoRaI6ZUJiuMbKDElg=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 1793824265463463.39423035620416;
	Wed, 4 Nov 2026 12:31:05 -0800 (PST)
From: Enver <owner@ph4ntom-rev.uz>
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com,
	kvalo@kernel.org,
	linux-kernel@vger.kernel.org,
	Enver <owner@ph4ntom-rev.uz>
Subject: [PATCH v3 3/3] wifi: rtw89: restore channel after monitor interface restart
Date: Thu,  5 Nov 2026 01:30:51 +0500
Message-ID: <20261104203051.564-4-owner@ph4ntom-rev.uz>
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

After the last monitor interface is removed, the hardware is stopped.
When monitor_chanreq remains unchanged across the next stop/start cycle,
mac80211 does not issue IEEE80211_CONF_CHANGE_CHANNEL, so
rtw89_set_channel() is not called. Hardware initialization completes, but
monitor-specific channel and RF calibration state is not restored,
leaving monitor RX and injection unusable.

Restore the channel after successful monitor VIF creation, once
pure_monitor_mode_vif has been published, so RF calibration sees the
monitor role. If channel restoration fails, disconnect the firmware role,
clear the pointer and synchronize RCU before unwinding the link. Preserve
the original error while logging any disconnect failure separately.

Tested on RTL8852AE with 25 monitor delete/recreate cycles, both with and
without concurrent raw injection. Post-stress RX and injection succeed,
with no new kernel alerts. A forced -EINVAL test verified the rollback
sequence and disconnect before link cleanup.

Fixes: d9204e99b696 ("wifi: rtw89: do RF calibration once setting channel when running pure monitor mode")
Signed-off-by: Enver <owner@ph4ntom-rev.uz>
---
 drivers/net/wireless/realtek/rtw89/mac80211.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/mac80211.c b/drivers/net/wireless/realtek/rtw89/mac80211.c
index 5404e03..caaf817 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -189,7 +189,7 @@ static int rtw89_ops_add_interface(struct ieee80211_hw *hw,
 	struct rtw89_vif *rtwvif = vif_to_rtwvif(vif);
 	struct rtw89_vif_link *rtwvif_link;
 	u8 mac_id, port;
-	int ret = 0;
+	int ret = 0, disconnect_ret;
 
 	lockdep_assert_wiphy(hw->wiphy);
 
@@ -245,6 +245,9 @@ static int rtw89_ops_add_interface(struct ieee80211_hw *hw,
 		if (ret)
 			goto remove_link;
 		rcu_assign_pointer(rtwdev->pure_monitor_mode_vif, rtwvif);
+		ret = rtw89_set_channel(rtwdev);
+		if (ret)
+			goto remove_monitor;
 	} else if (rcu_access_pointer(rtwdev->pure_monitor_mode_vif)) {
 		rcu_assign_pointer(rtwdev->pure_monitor_mode_vif, NULL);
 		synchronize_rcu();
@@ -252,6 +255,14 @@ static int rtw89_ops_add_interface(struct ieee80211_hw *hw,
 	rtw89_recalc_lps(rtwdev);
 	return 0;
 
+remove_monitor:
+	rcu_assign_pointer(rtwdev->pure_monitor_mode_vif, NULL);
+	synchronize_rcu();
+	disconnect_ret = rtw89_fw_h2c_join_info(rtwdev, rtwvif_link, NULL, true);
+	if (disconnect_ret)
+		rtw89_warn(rtwdev,
+			   "failed to disconnect monitor vif during rollback: %d\n",
+			   disconnect_ret);
 remove_link:
 	__rtw89_ops_remove_iface_link(rtwdev, rtwvif_link);
 unset_link:
