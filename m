Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793824292;
	b=gRvranHmH6KBcoMhLF1XkWaTCV1TMQ9gAOqEG6Yl4hBcpTm9yBkwuBGP2jjNydeiXkcU
	 K/ml2AKSNN8vU8yyQqsR9IPfw6sHZ2ErWj6oBbmgLAUFRfN1/Wmjdx8wFFpQF0J9Lgpo0
	 kW1Qav2ezqVMRwpazw7+Hlf6M/R8dlBkpOsASbdVmQTKgA/MJFXjCxv2Kvpzo3H/HwBuq
	 kaW/DNxz6NNa/nIargXwbGkR+Q1Sskq3eCox2UBTKVdTE9WGZD+973DpJT5Mnm7g9LO7l
	 +xYJRGJr+IOJSFQ6nAMXuAltl1h3Z+MOV1A3LhRdD7iPwhQilqQxbGyEjaQdooYkvyg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793824292;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-ZohoMailClient;
	bh=WmN1gTT4O/ohMwVK4nGidl/5nWOhLQOBMq3plPsqZqQ=;
	b=cmfZKeUjIny2eMPoMePSr6ARZ0h1h6KEyErUgia51VZgvQp1zWauPRleKWAS4JHzFEX2
	 y8Q094JrgMYF45Yk/tFsNNO8nZ2MWLTAU0D2WalpfsdyifcGrdmwsyZdd6rlzaZRncFL5
	 Iqhoylek/mmGiKXfnRTQK6GmBLPz9QwePpOrkxUsPvZ784HTsvqtfaxzTbD8gUtTlrijb
	 AfrfRClK2iuH0Uh9gYH360IPcIGEKOXKqFNP+bOpj2w/X1GelQmUfrXEETTpeZpHmb2Ff
	 z2VtuvqCvwd6D4vAcBMWCrXnEC2WvxuyChhx93gHMqwii1s8hh+aDdXnNNWEU4KfGBQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ph4ntom-rev.uz;
	spf=pass smtp.mailfrom=ph4ntom-rev.uz;
	dkim=pass header.d=ph4ntom-rev.uz header.i=@ph4ntom-rev.uz header.a=rsa-sha256 header.s=zoho header.b=Y3zttfOO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.54
Received: from sender5-of-o54.zoho.com (sender5-of-o54.zoho.com [165.173.182.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3A6606AB20;
	Wed,  4 Nov 2026 20:31:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B3A6606AB20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ph4ntom-rev.uz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ph4ntom-rev.uz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ph4ntom-rev.uz header.i=@ph4ntom-rev.uz header.a=rsa-sha256 header.s=zoho header.b=Y3zttfOO
ARC-Seal: i=1; a=rsa-sha256; t=1793824262; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=nSS7M2GgHL9csmlYMyBOkXsSHhSKMFycT18CaBO80u4AjZq8KC9/2QaZ3xC5kXqM1xr6s13aVVRf2p9OL1GouHuhH5Rkekco1qI+haVmfd8gGI4EpCbaH2+H2LvfkNgVvtr6F1KfzgtezsFRLsj+8T2S1T3n5u2Xj/7pruviC34=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1793824262; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=WmN1gTT4O/ohMwVK4nGidl/5nWOhLQOBMq3plPsqZqQ=; 
	b=mhVfwWAPSWXtoUfWbQIKp63jlBS+4TptmMQuP558oJDzjUmy2bGkaBXUKA//YrddHthiJki/Y5x5EouILuZgo5YKJ8Zg8gUl8z/Wx6irGY6GxsDFLHaAmy2n78zCn4HOsrhC6qRoeAki5jCfMWyTUM6AHOL7gjjdSKxVxgZCPaY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=ph4ntom-rev.uz;
	spf=pass  smtp.mailfrom=owner@ph4ntom-rev.uz;
	dmarc=pass header.from=<owner@ph4ntom-rev.uz>
DKIM-Signature: a=rsa-sha256; b=Y3zttfOOgjdVtdmUnT+LW8eFINcvveM/pQlLaH7raOLzJbbgaZ14geTkoaSo0eSEefntGruVyqZMMiDmQSf0NbN6XaeJs82yg0apEEE1P+MEYhSn9mYM2hw9+P45o9QnTgi3GZ53NNM0FUXtpREjeOEWb3qsMDnbOO/nJ1ZBR8rqV7K1zPfwSjkqmgh9WzQyrbGmJutPtyJzabpPb3bZ1gBSfpSOZE4wlxkFPlyVpEQSgOm1sK1zCmbcoi+Vlf50VrUi2FSMSSdmsKGM4rMbXUQx3KZ/zQusEgamMZpAwpJUia8jJx0lBgdVDw8GQKQM7q2tL2yqUIU4SWaBarJW4A==; c=relaxed/relaxed; s=zoho; d=ph4ntom-rev.uz; v=1; bh=WmN1gTT4O/ohMwVK4nGidl/5nWOhLQOBMq3plPsqZqQ=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 1793824261013460.15440865214396;
	Wed, 4 Nov 2026 12:31:01 -0800 (PST)
From: Enver <owner@ph4ntom-rev.uz>
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com,
	kvalo@kernel.org,
	linux-kernel@vger.kernel.org,
	ph4ntom-rev <owner@ph4ntom-rev.uz>
Subject: [PATCH v3 1/3] wifi: rtw89: fix RX filter configuration for monitor mode
Date: Thu,  5 Nov 2026 01:30:49 +0500
Message-ID: <20261104203051.564-2-owner@ph4ntom-rev.uz>
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

Monitor mode enables sniffer mode but retains address CAM and
beacon checks in the RX filter. On RTL8852AE this suppresses
frames from other BSSIDs.

Clear the unicast/broadcast CAM match, beacon check and UID
filter bits in the local filter value while monitor mode is
active. Keep hal.rx_fltr unchanged so the normal filter is
restored when monitor mode ends. The adjusted value is written
through the existing MAC 0 and MAC 1 paths.

Signed-off-by: ph4ntom-rev <owner@ph4ntom-rev.uz>
---
 drivers/net/wireless/realtek/rtw89/mac80211.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/mac80211.c b/drivers/net/wireless/realtek/rtw89/mac80211.c
index 9e6cafc49..bb6101ccb 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -377,6 +377,13 @@ static void rtw89_ops_configure_filter(struct ieee80211_hw *hw,
 		rx_fltr &= ~B_AX_A_A1_MATCH;
 	}
 
+	if (rtwdev->hw->conf.flags & IEEE80211_CONF_MONITOR) {
+		rx_fltr &= ~(B_AX_A_UC_CAM_MATCH |
+			     B_AX_A_BC_CAM_MATCH |
+			     B_AX_A_BCN_CHK_EN |
+			     B_AX_UID_FILTER_MASK);
+	}
+
 	rtw89_mac_set_rx_fltr(rtwdev, RTW89_MAC_0, rx_fltr);
 	if (!rtwdev->dbcc_en)
 		return;
-- 
2.56.0.windows.4

