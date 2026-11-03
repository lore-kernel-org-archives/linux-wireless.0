Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793718509;
	b=YXi531LxLG33OGMD8vxFHWSm4zxvwJJHu94fzT8T4oCvWWpYXmwo/hyyNSnxHSVodWAw
	 Ngfw8DeeH1RRYRCOGAghOS72Cbsxzv+7zGz25OSVcD4Qn4OqJHrAgTT6Izza+onXZ1RNu
	 CF/FW0A8RPRlZkhdxb04zFYaz5ulucyrGu8bLOg37WyS8WPT4vQyzZFyq6h/irTqfUZT9
	 hkPjBAJACoHc9n6vkhkOmc8ua3aH9A9LXrWxk3HS2Q0EgAlksS3j96+gzOB1lHJCXURmD
	 fvpKW4ccVntoUXNUrbm7+QKO2sQMpPhlFUdWEvPhGKw6OAqGNsyIUq27Vs/P4R9Pn/Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718509;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 MIME-Version:Date:X-ZohoMailClient;
	bh=AVJg1CCqlkILLBlml7f4PmJUIqCgbE9um+Tc5iIYm5g=;
	b=3vVwB+3GSFyukdbB2Htg4dn8gUhg2e8iV6JFfBYxjp++PYWEPKwX82o/hlBN1njyJ7uE
	 XLi23TXn3jjIEWW6UvEBRavEbO72iqPVbIG7GL3lGCE8yH3Jbkz1kz2GW7JBsC4xEhN6h
	 qi6Ry3HiRWID3qEza1K5ni91uIJVnIbMrsyjGKUu03G+MpXoArzFBuejbI47SmiR6K3GD
	 IrBREoKfZlpc+kjUxwjx8jAaSDgo3dxRYFA0UdBu+MvryQPd4AtewsHouiFDW5yFLe2CZ
	 OWoXAxiBp9r0J0LGp+FCwwhD7D0TnnyLuP6oVs9CFTO45whPAjoobTON9v9TIJ75nIA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ph4ntom-rev.uz;
	spf=pass smtp.mailfrom=ph4ntom-rev.uz;
	dkim=pass header.d=ph4ntom-rev.uz header.i=@ph4ntom-rev.uz header.a=rsa-sha256 header.s=zoho header.b="1d/Y/clG";
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.54
Received: from sender6-of-o54.zoho.com (sender6-of-o54.zoho.com [165.173.180.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC89B606A32E;
	Tue,  3 Nov 2026 15:08:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC89B606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ph4ntom-rev.uz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ph4ntom-rev.uz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ph4ntom-rev.uz header.i=@ph4ntom-rev.uz header.a=rsa-sha256 header.s=zoho header.b=1d/Y/clG
ARC-Seal: i=1; a=rsa-sha256; t=1793718501; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=fyVXajbhFMe3l2kwUUAtKmeCmcQ5eAgABnKb+OXIni4PAbVhOgRVEapvcSBGxhne9QDKPZhedlRkyiEuB7+ZEabkSLPKqhXG9mkONXSJnHdAjO/I2zlTI05ehNMCsUvETrnlQM1vhYvSW/h9hvYNqPrWRG6eGRV6MfzbJjFOTGA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1793718501; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=AVJg1CCqlkILLBlml7f4PmJUIqCgbE9um+Tc5iIYm5g=; 
	b=NNEwobGiQiWivds8CbAHnMCO6hCFY/E1E3QRscTn83H/QM2byPiAMgS07iEwUwz/3R+9w0mn4S8w1JfZN0yF+3Le9OV/V7N0vIqi9O7CFrVmfFCwiqXpVnESlr8GaXfFDPoEvPIgZlETEmrOEtJgie2JWnB2wo8VLl0Rv1ZvtiU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=ph4ntom-rev.uz;
	spf=pass  smtp.mailfrom=owner@ph4ntom-rev.uz;
	dmarc=pass header.from=<owner@ph4ntom-rev.uz>
DKIM-Signature: a=rsa-sha256; b=1d/Y/clGxwTrVB2W0ctWAxe7RUWxnbnsWWzgyT9wjhNHHoofmUCERlrYO2/GXrep3OFcrWqkKnHgRESIacWOlLoWLMoBXUzPEHTXaTQiaaAlL/PtPdknyFwaVUasftSBQL6nyUKBI7tSGr5iJFXnF1oeXGN1XIplrCYw1/COuCM6BUl+lHvPve5H0hRISqJPV9P2WPkDiebdV0Bzmcn4Y2DvS924fBlpFLJs2lYCvfzyLJIOMbU9oSR+4VTxhU0MHEsUDAm/AyDDaySXlmcC6YKW4ztspFsot1wyCyOyNtHomNyRkdBVdU3Uiz1VgadzsdL/6rkaJwH0W0Sc9LdsvQ==; c=relaxed/relaxed; s=zoho; d=ph4ntom-rev.uz; v=1; bh=AVJg1CCqlkILLBlml7f4PmJUIqCgbE9um+Tc5iIYm5g=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 1793718499438724.8792998876271;
	Tue, 3 Nov 2026 07:08:19 -0800 (PST)
Message-ID: <179371849554.20972.16232816164394690660@ph4ntom-rev.uz>
From: ph4ntom-rev <owner@ph4ntom-rev.uz>
To: pkshih@realtek.com, linux-wireless@vger.kernel.org
Cc: kvalo@kernel.org, linux-kernel@vger.kernel.org
Subject:
 [PATCH v2 1/2] wifi: rtw89: fix RX filter configuration for monitor mode
In-Reply-To: <1a19b7cce82.5dc2e93-44860545.1830508576953059669@zoho.com>
References: <1a196d6dfbc.35537d221913104450.3720060455831933789@zoho.com>
 <b41e89b40fc640879b9d71b86311f900@realtek.com>
 <1a19b7cce82.5dc2e93-44860545.1830508576953059669@zoho.com>
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
Date: Tue, 3 Nov 2026 07:08:19 -0800 (PST)
X-ZohoMailClient: External

In upstream rtw89, enabling monitor mode (IEEE80211_CONF_MONITOR)
configures basic B_AX_SNIFFER_MODE in R_AX_RX_FLTR_OPT. However, on
RTW89_CHIP_AX hardware (specifically RTL8852AE), Control frames (ACK,
RTS, CTS, BlockAck) and non-matching BSSID frames remain suppressed by
the hardware MAC Address CAM filters.

To ensure promiscuous capture of all 802.11 management, control, and
data frames:
1. Clear unicast, broadcast, and multicast CAM match drops and beacon
   BSSID checks in rx_fltr when IEEE80211_CONF_MONITOR is active.
2. Ensure power management frames are delivered by setting B_AX_A_PWR_MGNT.
3. Apply the adjusted filter across all active MAC indices (RTW89_MAC_0
   and RTW89_MAC_1 for DBCC) without clobbering rtwdev->hal.rx_fltr,
   allowing the default filter to be restored when leaving monitor mode.

Signed-off-by: ph4ntom-rev <owner@ph4ntom-rev.uz>
---
v1 -> v2:
 - Integrate RX filter adjustment directly into rtw89_ops_configure_filter()
   rather than maintaining a separate helper that overwrote hal.rx_fltr.
 - Configure both MAC 0 and MAC 1 (when DBCC is enabled) seamlessly.
 - Remove manual register writes to subtype filters and preserve standard
   filter restoration when exiting monitor mode.
 drivers/net/wireless/realtek/rtw89/mac80211.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/mac80211.c b/drivers/net/wire=
less/realtek/rtw89/mac80211.c
index 0672d13..33a6598 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -369,6 +369,15 @@ static void rtw89_ops_configure_filter(struct ieee80211_=
hw *hw,
 		rx_fltr &=3D ~B_AX_A_A1_MATCH;
 	}
=20
+	if (hw->conf.flags & IEEE80211_CONF_MONITOR) {
+		rx_fltr &=3D ~(B_AX_A_UC_CAM_MATCH |
+			     B_AX_A_BC_CAM_MATCH |
+			     B_AX_A_MC_LIST_CAM_MATCH |
+			     B_AX_A_BCN_CHK_EN |
+			     B_AX_UID_FILTER_MASK);
+		rx_fltr |=3D B_AX_A_PWR_MGNT;
+	}
+
 	rtw89_mac_set_rx_fltr(rtwdev, RTW89_MAC_0, rx_fltr);
 	if (!rtwdev->dbcc_en)
 		return;
--=20
2.53.0
