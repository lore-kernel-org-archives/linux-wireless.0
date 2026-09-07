Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazolkn19012011.outbound.protection.outlook.com [52.103.32.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D101353A6B;
	Mon,  7 Sep 2026 04:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.32.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788755020; cv=fail; b=sLheISEHM+dc4n9upOtqK56TFLeeVyisX7p1ma7BU/sx+HCmehAPzXHohUqVh2Yfeqd+Y/RsAEii/Iv6lswgXhTvcNAcnie6feBynblCE/ON24esW0ztoSHLeZ5rNNX4KG0tNc9yvKsv7/0cwuVZiDMiTX+2ny1A3kDbE3F4b0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788755020; c=relaxed/simple;
	bh=Nzhv0aEcFAV6pW2yFZOCIq7cWuv2BUfi8dwbRxp3oCM=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=qDzMZPK97hxzK1VnUdBnugrnWCtlax6DBbZDwhbuw7F5XtGkh2kDe7v1gp+X2nsTvkPc9qA7gJesw3N6o2/k6ekPkVaJzs1LdrwkPNEeVvxfVHJ2KPBdL5gQIJoDFxRBpoiNOlpo2mpLcLDoQMo80wZDDfzR5pCgbn24UvM3C/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=EpAvolAU; arc=fail smtp.client-ip=52.103.32.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="EpAvolAU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hEoAFWMooI3UFa6I54ERN+Lgu4MQVYObfLTFaxas8YQgDcaRA7DneT1Ftgs+bK/cCLhTZr+bo/qvUaNt6C+mvC5I54ypMYjRUKsFoJtOxynieR5kmJOWdNetsrFV0yfuaGZy0RW7CvDEjc8ERv9MtqgjseotSwW0PN/YYdE3HB/JCZ2PSy6kOx6sA6MdczeoQ0eB0naPBm0jQgDZuF6zbxv9n/CHeKZxFPNRcMWiVryyP2p9KJ9eAwsro1SLT8Y2IMloLiwy8mmOyx8G7MAEM9cEeGGhsF8Q3MqygB4pOLBs5jt43EVVO/VD6Xl95MIWHB7JUMj36TE0lvROCg3IcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9rwHLyrCPW86ELFlPj4lXwFAUqdw+8CabXMDrtY9CHE=;
 b=is+77vnl4Qm3o6IVFvGbQHwatICOXwpepu334CxnwnVI+EZJvBivzOkrTEWJ/7N4ijsGl1jx0g+5mvSCU/8gp18v1WlMlZIcokfZnH3dH7ePM1fhuRNGzIekk837PPKAmMe1Yj8+KXZxHwyMhggH4KWM99t+OTpkOLXXRazKpumNZF+cJccbe6AEA5pX0AuHqop9DFokQ0/A1GyoOdsPjm+que47sZTSsWJYpFQMpkd6oOx3H0H80dzbdJpRBqAPWUUvvnP/cBQc6T65wPTlTk9BQfHaocckTBCdlhQPmwWuumnReU4UzNY2J2Rixjbw/dqeUHEdfRNs3JvGwvg4Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9rwHLyrCPW86ELFlPj4lXwFAUqdw+8CabXMDrtY9CHE=;
 b=EpAvolAUOxban5Z1uRi6su6jxOgXUxxsGK/RjiCa+b76uq4WoJy4O0bCSDEd6YbCK2rqaMFscAoGS+W+yOeOKl45aIPYHv6sjV+i9/ka8NdAkl2oMiqmAvM0/t97SZGgkH40wP5ZLqiU3gchoCEOx8DDFdfzayYANPeUES4Uo2hJeXA4AePx3d5eod/MA4sfJEA06wbpbaUD1aco05Dq9rmZxNXmC3/rzE6HY8VThxpicbgPxQz6LqL35YGJ+ANLdkVnz37N0Z8Z2pPSuhLDSjQYDxkaYsxke4zXIBMvVlomcwa5poJw/BNu8DhwGNsMO6aS6p+5y4tO0KgMKPZBtA==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by GV2PPFB01012AFA.EURP251.PROD.OUTLOOK.COM (2603:10a6:158:401::b64) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 04:23:35 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 04:23:35 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: Brian Norris <briannorris@chromium.org>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aamir Ahmed <elb12345@hotmail.co.uk>
Subject: [PATCH] wifi: mwifiex: validate queue_index in WMM status response
Date: Mon,  7 Sep 2026 04:23:32 +0000
Message-ID:
 <AS8P251MB0001511A9526DAA53E825C5EC8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0010.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:150::15) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260907042332.533695-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|GV2PPFB01012AFA:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bd0b2a2-1384-4129-b792-08df0c97c84d
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|23021999003|25010399006|15080799012|51005399006|2604032031799003|19110799012|8060799015|12121999013|37011999003|25031999004|55001999006|24021099003|5072599009|5062599005|40105399003|2607281247196008|3412199025|440099028|26104999009|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/Nlc0hjZChEKpn4lDOLqi0mhro1zB2FcoXjT4AtkvWqG9WJuR/aleyOPmhtl?=
 =?us-ascii?Q?Enhu242sRwtMLREyvNzCiqpQiWZOH+oZcAYtwQIv3DN1ZzW6Nw6o/GBMkjMX?=
 =?us-ascii?Q?GNoCoi/hzM8ACPxEsvyzuYvaBNSwTbR8fquicNHOd6au/IL1M5oNnIIYQxlR?=
 =?us-ascii?Q?PIS1jwWruV+lmX27op10x8kdymP2aoAPxgGRHTEqQk/vTz828fMMK8j/kPLA?=
 =?us-ascii?Q?oaYG6bCksSrcoyECsLcfg8Doi4+K2Faef1XF3KZzzKu5cVfRe+zx7zlgMetH?=
 =?us-ascii?Q?A4EwikrsSW+muglrzj1SFIgjbgSWem7U+cK0URVWtcTr6vnuHriJR/U13zD1?=
 =?us-ascii?Q?126HVp9+vP+mN9Cr0mgYmFXbPqo0CvRxuIr6aPsivIUl0KiOuvRpb6jCul3F?=
 =?us-ascii?Q?1hu5HhfJPV5F/7PjzJO+xf072FQpk2UBNV3kKZptaMD6jSxxYMIzk10bpIP5?=
 =?us-ascii?Q?OCHsrFVdQsKOBRtLMmM+FMKi/tv4Ecigzwhfxee64y5GXx/KoR2iro1vKbUM?=
 =?us-ascii?Q?VoNp9a5IM0W17rEZMAuyxxKkZdfRQ7fIGugnSIPhoQKEfix0dhXtJE076+xb?=
 =?us-ascii?Q?2gGw7PN2bBherF9jhySQySUUySxKAn3j8Lv5EjhxAuE4Gk2lokN6dU3zTQQX?=
 =?us-ascii?Q?y3Yo+qbh5Rjg9gme8TpQdOdz1eZhDZHC3Q5NcAzNDgF7MJXs8/Q2P6t3scv3?=
 =?us-ascii?Q?aDckxD1RLKPVWW2eOrWu1kIH3O7nmAQ2dgdYL7LfslNkllGF/aukg/ookk2G?=
 =?us-ascii?Q?APouSQskqd0KQtxfQVQOkKozohVBBsDeNZP1cxfZ1FRxEtq0xz2P2/+Nb8nX?=
 =?us-ascii?Q?D3gZ0TyN5c81pQYYF7PY3tVvMB/D0CpwgM4fZbW2YBM3UK6uE8anfOR/N4O3?=
 =?us-ascii?Q?JgxgjghWxc1Obh3bqOYB1zieSaAkEa29ycVRU4GLGHCINHjELwv8ceAmEvaT?=
 =?us-ascii?Q?lPDGfgxijofnQk+wcmgKM1fJlIgftMUliw+Kus7q07jHSEJ6MHoSeZMk2MZr?=
 =?us-ascii?Q?Dm2BG802Ra/l8ejQ21YyqKYoPv8AisNAER+7mG+OmwH2VUUX06Vxjt78vHzs?=
 =?us-ascii?Q?Gj7WSeZS/BnaE2uf+clHgxa/Y8EzkoddF7+DBZoca50YHTXBef1kCajjwDgp?=
 =?us-ascii?Q?14cCNLDGLTR3y6EPFTyPDwmNBonT1TK3PxGDeE779A91McSdKP03J9I=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rqtHXzg/S9vRzxktTUCbgTQjXmn8ZBXb1vYHgKROWbCZwDKogk6kj1D27SU8?=
 =?us-ascii?Q?5kuUx+TW9xNs1Pqk/O0fa5N1JCsMDJ8lWy8yvzKs/NIC2cBQPN+qr6iZ/RX5?=
 =?us-ascii?Q?ptr2tTvgOymNWY6EkD4zjoTtd25MMQ6xp5oasXSYpgxRBjA7/JoFIcCbscMj?=
 =?us-ascii?Q?C4P8yquMROY1r59tudyHpsYFy9dLg+yv1rYruEskYBUdWp4sHz8hGebkeKlU?=
 =?us-ascii?Q?XDLebpdOvo1zKsTra+0Ve4nEemfy+hRGBR6AIFLVUElTW5pdOjHwE6KHY3wn?=
 =?us-ascii?Q?rqWmL9pVbIRV7eYuc0h6tLEFFn6A3TyQbgFn3HVU35f3BUf5bya1g3kY/DC8?=
 =?us-ascii?Q?cmldNjv4m6o83P+5LES6yre6+yg6YkfVDthNITX/yJAMYdJGBR2OKCD8V9HL?=
 =?us-ascii?Q?t6iyWsUzhRqGVwomkjXo5+jTR7woAjIG/sKZxkVb0kuzd6c8Rq6QWTyIV42R?=
 =?us-ascii?Q?4auaAekbQhwz2i3+d+UCsKHkNSf4rzGJxw1HUsHRfrfs5aYtH9iz9defZzPU?=
 =?us-ascii?Q?/i5t64IcsDWJR8jj8AJxB226SGRjuYP/9qGNOcgqJYU3danF5jfCGtrx/x5G?=
 =?us-ascii?Q?Fm5GVDs7SxHb1SbeXV3w7gFZ0fGhXUfN0iBmsG8QfJNOY2uPpfRBarEEa9Y9?=
 =?us-ascii?Q?eNiMEl84H7X3wp6ZqdZaRsJTW1OgZM0KT/xSVvcomaoRFLfogm03/8vuaGv6?=
 =?us-ascii?Q?MANZd8lfZJfS4Nrrn/nAdPTL4aNaV2uZNsbTkWPXa7zpnryuj5nXPm9bnmH9?=
 =?us-ascii?Q?6JDKXDmRY8FC64OOMuL90WLcMTG0CvDaJ7i+59t93ZDTTrhhOt5cPQeQB6Tu?=
 =?us-ascii?Q?WypCeABtMmT9efOnZCd7EUeBPBXQO5foUYN2DvAuh3vukZFQ/eU1WeHn5+1E?=
 =?us-ascii?Q?vSjrbXmE4g+MTo5Ygece/kMHqj3bivoBtrGq0fnvcuKNcrC9bvkDMBui33QT?=
 =?us-ascii?Q?xFo6OAyo/izyw/UDSGGXpXdGFiGPufSuPP1WubKarWV878A9DEuMNpHd0Jwm?=
 =?us-ascii?Q?hry7RI1OMFIt1mQKe6VDDe8Xf5DVxahjhXjagtgW4Ltq6Yv8n60T+UCIozs1?=
 =?us-ascii?Q?6ZNnPguoxFCz33XCO3Fx5EaYYu7nM5S0VGzEP3jQ1lZSoJHR3Klvakm/j1/y?=
 =?us-ascii?Q?oOqhQ/YSVcHS361NBCZwH2CddK7wDhcFYcG4mf+IbXSPqD7AhvdaukcsNCi7?=
 =?us-ascii?Q?e5KELhC60nyW64mH5FmUyIKoZw6OrY38CyGiw++DGBojgkjN7Hsr7EaD8P8j?=
 =?us-ascii?Q?k2laavNbRc0te5jsc1uzAC1jJNTLSXDEmvHYKAz/FkeQscCOnkPxumvwOSCk?=
 =?us-ascii?Q?7DoWtJVQ0PlTSAJ27hDPtPrnzbyneodVuRUPGI9q7NQetzs+o8s9pgEJ6wDL?=
 =?us-ascii?Q?OhjCLYr6os+X8rg70YZDC6teX3Ynyih9E960PHMXAi6ao4UXnfQEQRcEVk8J?=
 =?us-ascii?Q?5o0CQSd9+hgc6WD9PsL8Ryyphq9dPsyO?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bd0b2a2-1384-4129-b792-08df0c97c84d
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 04:23:35.4248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PPFB01012AFA

The queue_index field in the WMM queue status TLV from the firmware is
used to index into the ac_status array, which has IEEE80211_NUM_ACS (4)
entries. A malicious device (especially via USB) could send a
queue_index value >= 4, causing an out-of-bounds array write.

Add a bounds check before using queue_index as an array index.

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
---
 drivers/net/wireless/marvell/mwifiex/wmm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/wmm.c b/drivers/net/wireless/marvell/mwifiex/wmm.c
index 841505e83c7f..febea68487e8 100644
--- a/drivers/net/wireless/marvell/mwifiex/wmm.c
+++ b/drivers/net/wireless/marvell/mwifiex/wmm.c
@@ -943,6 +943,8 @@ int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
 				    tlv_wmm_qstatus->flow_required,
 				    tlv_wmm_qstatus->disabled);
 
+			if (tlv_wmm_qstatus->queue_index >= IEEE80211_NUM_ACS)
+				break;
 			ac_status = &priv->wmm.ac_status[tlv_wmm_qstatus->
 							 queue_index];
 			ac_status->disabled = tlv_wmm_qstatus->disabled;
-- 
2.43.0

