Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazolkn19011027.outbound.protection.outlook.com [52.103.39.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33EF0331EAE;
	Sat, 12 Sep 2026 16:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.39.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230039; cv=fail; b=cI2m4jzw3vCS/UbqQyBmKw7rnNmaeixuP53C351Ns0TGmDEGfTNl2WEWOkfgDxWP0qDvzc1PHJgfSr2Ilq1PLUC12S6FozuTleyaMSXXZ3yrP9pxp7vCkntvUbEGd4PgXaJwbUdDl2SGOTAdbI8iAXo/YKrqr7qk8xdaEPdQVlw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230039; c=relaxed/simple;
	bh=/1/Kj8whxDVQ0Bc0dmMQa9gzAvQi0m5szvtq2fpr0lA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=bqUm+3F7mf+xDh+d7vCYC10JAq1AIn1XP2bLeF2AoGHmi8AqbNtlytyXfg3FtsnNP+6Fu1nnUoyL6Xd9gfkdC33arYNCI3mSFC9oCjs6nbkM5GNDXpxr5GlX33e6yK4rzWxzLmBAWWbOsvOqwAb2buW1lGyrubXIYTMctCDhdP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=WoUu8lld; arc=fail smtp.client-ip=52.103.39.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="WoUu8lld"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O4FHrB7gHI6RmgltJAB7agXEnjmwuI+d/tqWk4YP06wXMwa3n4KG5GEeSopfcGhv4ohgJTO/7sGeadkvTlPO2jx5qYWTQJqauq56K1l+B3/tWkm7Q2PoCngGRGEKaoyW9mEEg3vTzYaRKvxtq9lRZM3Y/LymOqSyWRudohj6hsHoDOLcbAig3VbKns9TwBLxG9PpcK2NbdIl80ytMyd8Ucoyv214yg9bQYxlbaiVgQODYzImiKjxEF7dfo9yfcd5k+749sYJX4c/eU1AxKzCNmoBonzRAt3SDi9JdKiYm6rR4Dg8SLDVLS4/F0Jp2s2kezrXRqakrw/IwlU0mGrdkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YKhjGC0g7p7vWQNGY8Q2fylH9GGQOqQkJXsXhm/NWm0=;
 b=vGnDeTw1/57FshEA2CRBHWudc8S66uFFIsdlGy+XW/ILC2BXSFQdJpenK3J2pQnK8pCqIk4HgW/9pkqZaEolKQeEpaBpS478FPkSzorfKQ7ryjTEQvPzEnVrGzlhb+0/+Rz+MHvjTDXaZsUBlD8IB+GnHaIWA+ECJHupx+nTCONLtkkF38NyThUtkZRMOrPatPU79qbMr8FSquf7/yAY4bG1A9lwCYikP9sl86k6MOSzl3ntxLf630jH1GRL1ui9r8xHP219vouu25vAEzVrw3W5WVPEFGJqTrPPiaEBBlbbHB3LwjDW2ersv/kN+oLOQD+BvHgCyGrTmWWweNbQKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YKhjGC0g7p7vWQNGY8Q2fylH9GGQOqQkJXsXhm/NWm0=;
 b=WoUu8lld8CM5OG7R+wxLaBVbER7LLDMd+6I34t7HaHIe9BN94PfcGsvhWgKe4dtMl8p87aKrrfFhj5lfpI44AROX6N81Qy870WXG1jlw6Mq1BsE/op3h76dM3eq+g3LpjMrEjk7yCNYCUMRVagydK2Ss2x0Biz+9VjwUsrBb52pTZ/AKiSCU7KgI/5apFkiEdGBgs7B8bGFvd58t+ah2YPnACfJY8eRYaEKAPjvpdVeAy4ivFYOgNMeNLWDfzMoqncMpxnuAJxw3HC6Vj7zZzsYq0EZ8FRVXuitwuOWwrNl33q36JFZGHW8PNGSQZ3b4i+Cup6bGx7hYFh3ww58DTQ==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by DB4P251MB0880.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:380::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.11; Sat, 12 Sep
 2026 16:20:33 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%3]) with mapi id 15.21.0406.007; Sat, 12 Sep 2026
 16:20:33 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: chunfan.chen@gmail.com,
	Francesco Dolcini <francesco@dolcini.it>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next v2] wifi: nxpwifi: validate variable IE lengths in beacon parser
Date: Sat, 12 Sep 2026 17:20:31 +0100
Message-ID:
 <AS8P251MB00010E2945A1BE91EB5415F7C8BD2@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0647.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::22) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260912162031.38848-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|DB4P251MB0880:EE_
X-MS-Office365-Filtering-Correlation-Id: 2107b83e-808a-46ca-7440-08df10e9c502
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|12121999013|51005399006|25010399006|4140399003|8060799015|23021999003|37011999003|25031999004|55001999006|19110799012|24021099003|41001999006|15080799012|5072599009|5062599005|40105399003|1602099012|10035399007|2607281247196008|3412199025|4302099013|440099028|26104999009;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lTcpGVfyOTcUIHrHbhSMudTnbMM9p0QDiJ2YLCpoAdxBCItN6SX2QGhVmlKK?=
 =?us-ascii?Q?YH3s//vNleETdRja0/vMMeZrY+iAtMQfnQaYHIDgx1n/6NIo/P+m/+SxoFDt?=
 =?us-ascii?Q?R4nmzdkPsnRBjiSuL4i63wA02YUL96aX5u47tM5YVcq70G9Sud++7OImrLug?=
 =?us-ascii?Q?h8fdVv3Fcci4P71cEOsnktCtmN3AQf2HGr2jysomt5O/yE5+dAwH5VKu8AGw?=
 =?us-ascii?Q?WrHVAn4wu9rUm+xAhNiJ2GxsKiIALp1pGonZgnDgPU+wgoBxGiP8W8Khln2+?=
 =?us-ascii?Q?dW6TyGEFtbo5l0jVQprRnYNCYgzcqgF/dCoOqEe773003eUNf7TC48esaBqm?=
 =?us-ascii?Q?BSWwqPLY0yFmajoCbIbobGDkGiRJX0g58xsNMXWE/zenXJ7NzCsUC8IY5jh7?=
 =?us-ascii?Q?vMFfBTi9Xd97HdFMOPECLFQb5KqrL17yLW20fBozheIQU4ItO64kfdnIC6tm?=
 =?us-ascii?Q?9jzvAa8PAW3lDVklqxbu8PfsJQGc/HCIZWilqa1EOFTOcbskvntOC5fPBZTk?=
 =?us-ascii?Q?hfUBpj3G6rD/Qou9A/5tFq4aQ5/Lc8AT+WcMCEjmP/uu8lWhb2AdhEQNXJ2K?=
 =?us-ascii?Q?r0qBia3s90NvfIE7vjT9CiK3R/AGUUfRJ+VrBSs6jxKoYTTEXi5p2j2K++8a?=
 =?us-ascii?Q?F7AB0Be2uh7uuti8uWjCFposT7ZQZenuUQ9QgVGj7XTPzCZLdoNTHLZmhxO7?=
 =?us-ascii?Q?PHs8pWLE8NN5tOBxrRZABDDJj6J0AqrCvRGMDRGYW+qEll8x24EO1a+HlE7W?=
 =?us-ascii?Q?b/D6nzFub6PKPIkQ60n+lZQdIB+vO0B9OFSdRGUYHD1s6d0brt82FCm4qW0c?=
 =?us-ascii?Q?hUWaQX48tXCKPcxufLuKs+7E4E3Z+eSV6pPrR9tHne2uSFIQii3zKkXR9bRQ?=
 =?us-ascii?Q?Fh96TuTre9fFPe/O/giNJtUWdzL5mCoV9/AuDOZQNkt0WMhti8nSK9F+JuJR?=
 =?us-ascii?Q?s9OZKw0wMbNPaTKv5saVweE1ozg1rQPskF59GnuZZOjk5hxxYjOwxcgMigTD?=
 =?us-ascii?Q?LzvGUHrjABX91MEkOz6HPydoAiosKjS72QNgALP9N/BzNBtf5x34afzz2wsG?=
 =?us-ascii?Q?5FY5Hj7mUj0buUZacUF0Ks0B9HjN3645UuBBUWNQDdXfnXAP3ubW9Ds6bSZT?=
 =?us-ascii?Q?9Dn1IGS/QyGMW7h/q6epvm8DTKUi8LGFuaAydkD6Xsf1C45bR7RddUIASkrL?=
 =?us-ascii?Q?0cDDTSFQFh9hi66G9sLIOA2DMwmKpHosfgpJZqR7jjMerV56ZVqyzkJp3Gk?=
 =?us-ascii?Q?=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Oetw4FmPJNKdGOTnvff6J6FgjMK7Q1Opb11aaFDvnjxue9PUl0VUc9aWa7gX?=
 =?us-ascii?Q?Cl/cuOuGZ1oFiOBMUIaEjI/qjGmRxicMa2KOzRBsLkkVO9yStg/gL/jU9VDt?=
 =?us-ascii?Q?7vYUnMWnGQTRQFMvfnrmkLQd5KeD+qDIl3nZCLeAKuQATMfOVwIshvk+xJY6?=
 =?us-ascii?Q?WMqAdbcJ61UVD+gWG2Oc4Wa8QcMPcjlpsOXQISIQIXQJ+wbD1em0W9YdRWny?=
 =?us-ascii?Q?vOoCNXytbqVj2W5nNtBpc2UIIXzLWznnpIzy61/QYgc0a+42Pbdr9VjX7VqJ?=
 =?us-ascii?Q?hEsIa2fMJP35hbFeaanDkPliiB3rxGfHwcz0N8I1qzJHaXIm8iMmpg9GlEa+?=
 =?us-ascii?Q?3LC7F7kDdngKPggpFwp4EA/Hlr0FFzu9DlXsWaWsWOMHsYaoVpKFpKjsGjqA?=
 =?us-ascii?Q?Ij2Nh/31Mg0NTRfopOVz1eJg7SV5uIopAkXXSLCzqVSacAO9J5aD+1BGWPhu?=
 =?us-ascii?Q?wI6E5dV14F+8QAy1R84nUVzQ42w+MurFPEgo6wQvs6GzKtjW93sBfvVn4pVI?=
 =?us-ascii?Q?ltWNZJ14mBghMSoQSQeNuCO8dw7+lnCqjkRSnI1apxk2ay2jyr3D76SbwVcY?=
 =?us-ascii?Q?LREJCSzOX+7M5fH6pCnRMtEsj4AjetltnuFwcqe/rAPr03O2p+bD2U0yP8HU?=
 =?us-ascii?Q?wGn+1bmtBa+6McDIMhedWIjT6woEiBCdUyuiKkCP6yC9P7IVISt9G6azVnRi?=
 =?us-ascii?Q?6No+6piFcNHAHsHuIc7gtvTtmljhGpnNCPn7OCyBa6kK0irTP/IaqMPE+4dS?=
 =?us-ascii?Q?HZ5GF3bR08XjPVzKEBUAgqntup+PQquGnO+1r9NtghuXQp3sSCN1chL799jB?=
 =?us-ascii?Q?SuhwFjwTUNo0obOawCnLO6cHqSRJlgAegTXQVjNG7JBGEUyyE0AsFUuypq8R?=
 =?us-ascii?Q?M85TnEpoq3eYnCnH65KvI+1o8G6SKtX28Npv0c3K6vp4b6q/XAP4iriPk1Ig?=
 =?us-ascii?Q?RFVLHT8RCuc4bhCIoe6/aNlDEsOsjOAa1r5jjJMJx0Hmz+WdaFx3NNG4a8Hc?=
 =?us-ascii?Q?hgp4zlxhjFZw8SAsLl/ycNK87eMACVtSkB+ehTqOJaDnQrSWHT9eP5pVLiJ+?=
 =?us-ascii?Q?MD3iQMG3lDjQBgifh/KWWVvJJCMmYDZPFrChq8kFt1Y0pSEJ04m+Dj58yWWl?=
 =?us-ascii?Q?md554Sg2dtXcctKT3fqIKTJXn+Vm8BLP13CEFmZMMY0Pz1CH5fFE8AnH+CZ5?=
 =?us-ascii?Q?eMBTFvhRfCUe/K+CGKe5C6bb01ZxeUBDf6VH/uTh9Ybnbw5x3WyV397LuafZ?=
 =?us-ascii?Q?3VzxsW+j7r546G/XW+b2qrNFrJy8pvUXkpD17QhaijpopNQaLCy3k2kh+Pne?=
 =?us-ascii?Q?TNRlJMQxUlOshGIQpzRDKYHZj3V+B2+LEpCYoj9P+HSe7slRPHdVCHlqyMHt?=
 =?us-ascii?Q?fZCHZ3J+HsR1KxA6hIezPfG1n9v9J+EhXkoJLZWYLY2HJ8xf6q9qewMSPpxI?=
 =?us-ascii?Q?0QUbX250rYsipVhQrSGIT2NGV3P5fSWq?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 2107b83e-808a-46ca-7440-08df10e9c502
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2026 16:20:33.3017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4P251MB0880

nxpwifi_update_bss_desc_with_ie() stores pointers to the HT, VHT and HE
capability and operation elements, to the operating mode notification
and to the 20/40 BSS coexistence element, taken from a beacon or probe
response, without checking that each element is long enough for the
structure the driver later dereferences it as.

bss_desc->beacon_buf is a tight kmemdup() of the on-air elements, so a
truncated element leaves the stored pointer short of the structure and
the consumers read past the end of that allocation at association time.
Some of those bytes are copied into the association request, so a rogue
access point in range can both trigger the read and receive the result.

Reject the frame with -EINVAL when any of these elements is shorter than
the structure read from it, as the FH, DS and CF parameter set cases in
the same parser already do.

The extended capabilities element has no structure size to check
against, so nxpwifi_is_ap_11ax_twt_supported()'s read of
bcn_ext_cap->data[9] is bounded at that consumer instead.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Assisted-by: LLM
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
---
v2:
  - drop Cc: stable; nxpwifi is not in a released kernel yet (Jeff)
  - cut the commit message down (Jeff)
  - Assisted-by: LLM, without the tool name
  - name the target tree in the subject
v1: https://lore.kernel.org/linux-wireless/AS8P251MB00017FB955BDEFEEA1EA579BC8B32@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM/

Tested on a KASAN kernel with a harness that feeds a short element
stream ending in a zero-length HT capability element to the parser and
then copies from bcn_ht_cap as the association path does: unpatched that
copy trips a slab-out-of-bounds read, patched the parser returns -EINVAL
and KASAN is silent. I have no IW61x hardware, so the over-the-air path
was not exercised.

 drivers/net/wireless/nxp/nxpwifi/11ax.c |  2 ++
 drivers/net/wireless/nxp/nxpwifi/scan.c | 18 ++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/net/wireless/nxp/nxpwifi/11ax.c b/drivers/net/wireless/nxp/nxpwifi/11ax.c
index 96540914f3cf..dc1e747383ec 100644
--- a/drivers/net/wireless/nxp/nxpwifi/11ax.c
+++ b/drivers/net/wireless/nxp/nxpwifi/11ax.c
@@ -402,6 +402,8 @@ static u8 nxpwifi_is_ap_11ax_twt_supported(struct nxpwifi_bssdescriptor *bss_des
 		return false;
 	ext_cap = (struct element *)bss_desc->bcn_ext_cap;
 
+	if (ext_cap->datalen < 10)
+		return false;
 	if (!(ext_cap->data[9] & WLAN_EXT_CAPA10_TWT_RESPONDER_SUPPORT))
 		return false;
 	return true;
diff --git a/drivers/net/wireless/nxp/nxpwifi/scan.c b/drivers/net/wireless/nxp/nxpwifi/scan.c
index b77056983e83..d82ee8e502f6 100644
--- a/drivers/net/wireless/nxp/nxpwifi/scan.c
+++ b/drivers/net/wireless/nxp/nxpwifi/scan.c
@@ -1209,6 +1209,8 @@ int nxpwifi_update_bss_desc_with_ie(struct nxpwifi_adapter *adapter,
 				(u16)(current_ptr - bss_entry->beacon_buf);
 			break;
 		case WLAN_EID_HT_CAPABILITY:
+			if (element_len < sizeof(*bss_entry->bcn_ht_cap))
+				return -EINVAL;
 			bss_entry->bcn_ht_cap =
 				(struct ieee80211_ht_cap *)(current_ptr +
 							    elem_size);
@@ -1217,6 +1219,8 @@ int nxpwifi_update_bss_desc_with_ie(struct nxpwifi_adapter *adapter,
 				      bss_entry->beacon_buf);
 			break;
 		case WLAN_EID_HT_OPERATION:
+			if (element_len < sizeof(*bss_entry->bcn_ht_oper))
+				return -EINVAL;
 			bss_entry->bcn_ht_oper =
 				(struct ieee80211_ht_operation *)(current_ptr +
 								  elem_size);
@@ -1225,6 +1229,8 @@ int nxpwifi_update_bss_desc_with_ie(struct nxpwifi_adapter *adapter,
 				      bss_entry->beacon_buf);
 			break;
 		case WLAN_EID_VHT_CAPABILITY:
+			if (element_len < sizeof(*bss_entry->bcn_vht_cap))
+				return -EINVAL;
 			bss_entry->disable_11ac = false;
 			bss_entry->bcn_vht_cap = (void *)(current_ptr +
 							  elem_size);
@@ -1233,6 +1239,8 @@ int nxpwifi_update_bss_desc_with_ie(struct nxpwifi_adapter *adapter,
 				      bss_entry->beacon_buf);
 			break;
 		case WLAN_EID_VHT_OPERATION:
+			if (element_len < sizeof(*bss_entry->bcn_vht_oper))
+				return -EINVAL;
 			bss_entry->bcn_vht_oper =
 				(void *)(current_ptr + elem_size);
 			bss_entry->vht_info_offset =
@@ -1240,6 +1248,8 @@ int nxpwifi_update_bss_desc_with_ie(struct nxpwifi_adapter *adapter,
 				      bss_entry->beacon_buf);
 			break;
 		case WLAN_EID_BSS_COEX_2040:
+			if (!element_len)
+				return -EINVAL;
 			bss_entry->bcn_bss_co_2040 = current_ptr;
 			bss_entry->bss_co_2040_offset =
 				(u16)(current_ptr - bss_entry->beacon_buf);
@@ -1250,6 +1260,8 @@ int nxpwifi_update_bss_desc_with_ie(struct nxpwifi_adapter *adapter,
 				(u16)(current_ptr - bss_entry->beacon_buf);
 			break;
 		case WLAN_EID_OPMODE_NOTIF:
+			if (total_ie_len < sizeof(*bss_entry->oper_mode))
+				return -EINVAL;
 			bss_entry->oper_mode = (void *)current_ptr;
 			bss_entry->oper_mode_offset =
 				(u16)(current_ptr - bss_entry->beacon_buf);
@@ -1262,6 +1274,9 @@ int nxpwifi_update_bss_desc_with_ie(struct nxpwifi_adapter *adapter,
 
 			switch (elem->data[0]) {
 			case WLAN_EID_EXT_HE_CAPABILITY:
+				if (element_len <
+				    1 + sizeof(*bss_entry->bcn_he_cap))
+					return -EINVAL;
 				bss_entry->disable_11ax = false;
 				bss_entry->bcn_he_cap =
 					(void *)(current_ptr + elem_size + 1);
@@ -1270,6 +1285,9 @@ int nxpwifi_update_bss_desc_with_ie(struct nxpwifi_adapter *adapter,
 					      bss_entry->beacon_buf);
 				break;
 			case WLAN_EID_EXT_HE_OPERATION:
+				if (element_len <
+				    1 + sizeof(*bss_entry->bcn_he_oper))
+					return -EINVAL;
 				bss_entry->bcn_he_oper =
 					(void *)(current_ptr + elem_size + 1);
 				bss_entry->he_info_offset =

base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
2.55.0

