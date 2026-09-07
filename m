Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazolkn19012012.outbound.protection.outlook.com [52.103.32.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B042138238D;
	Mon,  7 Sep 2026 05:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.32.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788758796; cv=fail; b=Tq8fj4Xw/+hCScOvw/9DcxdnTZqdgUlElSbuX4IJ2XlmZEX6Z5DfO3VmxAuTEF5cFyh1LVnZnYeww+E0aKWe5n1/bhrPoQu50MINoTwLpZR/5MR5bow7FDUeEJ5qx//2WoHJc19dnv6qUkIAwSsdBoSImG6tEfPG0yOR64VDafc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788758796; c=relaxed/simple;
	bh=uPlkvV/enAl0ioUwNg5KZpOnDuUlNqEPfHz6L3Hko2o=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Fprei55hgjjJiW7zKtdzq73se0fYuPFwCEwMBiuU8/AVQ2pKmKM2H/udps+3MZgYispkVRs6Oze+xtBAAMNQsskbdk+gUdYKSfmvQB27aWAiNb3HFVXfprwcLMtEy3OqH1tkM2yTlTmE8JNinNHeoAE+jBVfWWY33JK8lcgGeM4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=nCdvE5Jn; arc=fail smtp.client-ip=52.103.32.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="nCdvE5Jn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EyiLM8SlfS4TAqCa/ujFIBSojZYqrMU6P2CdlMABm3QqOrjGo+OTCXUL+1jEWvDksioAH4kgd+rgZHE77nkJXJ4OZq1++OHRHYVmql38XmiKLy0IDNOl3CcIb4tbMMAjZPl1TMUGCc/Hq1GkyXGa7UnCwL+LEUeISI58Y5tiAliHzWzLJ5mK97510EPmp1MgQ+sWUHvXlUnwoePlL+rA2HdMBTQHQagquh7+zEuJ6z8nU995NOsJyHkpssLKCR0cNnrdkAiEhPAgEm+4MNekfWby0sE6vnaot2cykJu9qtXRS120avSaTLTZ+acNScc2121+TFkiS9lIThY6HDMSXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IO8Wz5saQVqbzoypK94Ql3y2Q8Gpm4QBCKpMzno6p7E=;
 b=IjsiNFo85PrtC/rAsOWdPVfHCNn83E+MR0sVx7xz0adgwx9kBw+lMA5j7+8D2qBGKnGE3fJwBPWgpuSwTSFey2iLHpHgy++hvkeJ73aF4IH8byMEe5aVBL7dr0IT79S6N/mjRHL6PonRvMCzYOB7SnSmK9vfDR5EeFlNlYuVsPfVOmcxeHdrWoGb1vw8AsJfhwP5c9cBEbXTovvbL1Beh5eDcLKjzsagTq/7dUEQHmuMS+Tu7vEmXeW2jhkU7px0urz2Owsc1JDqJ32p++9fSxxnOHnKN/kfyutvEOTsFpuOpf4GDiZz46q9cs1X4a2+9A6TU6TnP6z+U+YgFUlfWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IO8Wz5saQVqbzoypK94Ql3y2Q8Gpm4QBCKpMzno6p7E=;
 b=nCdvE5JnNF/OTJmHPT1eciutFtB31lv8QbRLUc7MV+Dy7zGtz2Q3YdGtsWPtOQbJFzb+doJI3RlTJZ2U3zDsMoyXv9T6an7fj7b9NvIfpmIW8jHfyZWIUQxfAofPlHxj5WeSgKO398eXXnVvY934P69AQ4XjbaSmCqUse9SaeaJkmycyUzW93vh1FRYdWIQDu7Hs7ego5teLnbsqS2WPF2ZQOUVa+HaqJXNxehZW8zsQwWiNCtbq347Np0h65bV/Zynyzoj+g1co/ZonHLvaJeMkGgk7xMGL1UWz1nfP18FSZua+nDJQxmwd8YeDqyWxfjl4EapC/axv12EmiEhRyg==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by GVX0PF607FB09A8.EURP251.PROD.OUTLOOK.COM (2603:10a6:158:401::815) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 05:26:32 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 05:26:31 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: briannorris@chromium.org,
	francesco@dolcini.it
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aamir Ahmed <elb12345@hotmail.co.uk>
Subject: [PATCH] wifi: mwifiex: validate intf_num in multi-channel event
Date: Mon,  7 Sep 2026 05:26:29 +0000
Message-ID:
 <AS8P251MB00019519B296346477CF4459C8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0489.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::8) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260907052629.550877-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|GVX0PF607FB09A8:EE_
X-MS-Office365-Filtering-Correlation-Id: f45a1970-e62c-419a-7a26-08df0ca09334
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|23021999003|25010399006|51005399006|15080799012|2604032031799003|19110799012|12121999013|37011999003|8060799015|25031999004|55001999006|24021099003|5072599009|5062599005|40105399003|2607281247196008|3412199025|440099028|26104999009|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YaU2sH8YBJJSOEMDfFZv8j20/7BMw6QpfWW65SFiKOdJo+rV+XxAx7SIt382?=
 =?us-ascii?Q?cKZhez82vSh9Q9ddaOBFM0H0Igej49TkIv0RwAZ+jCWTIl7NmryzbWgQO5Ru?=
 =?us-ascii?Q?JrhKyzgi2/q5M1mrBmee/oTX8VKUgAK+y/3kEjrEiJZ5/hItPtOPqfxK5dbl?=
 =?us-ascii?Q?kuW4ntMCR5+IMVid07f5xOI5J4uYoAEdXUi+dpc860wugk/CC4OiondP+cMF?=
 =?us-ascii?Q?aqFAu3xmPQQmSURnA7IlWVwBkeDAgd5kfelXpWGiZYSG5gOMfKK04wbKpIb7?=
 =?us-ascii?Q?VPKd+GOA/JRbQ1X+B4NHC7G28L1PdRgrVf4eFNoh9tWQmNDyNMjYX/Uty2Lf?=
 =?us-ascii?Q?L3NRnnHj3Joi2GaBxBOKGt5j4c8KX9itth/cYHT20yUd84KroldpakkCd0cl?=
 =?us-ascii?Q?cnkijQLvUzMOZvf9bYpLO2itQsyfhLcbFLu+tr+TCrOzsp2O5yLu4xWI/Sh3?=
 =?us-ascii?Q?Xp1Bzj5EDjPHSaqBVUp+6IrY2HJ+PFzLgHAUXyISjY957xR9kLai16MKP/hs?=
 =?us-ascii?Q?4rg9G2/WfdakeEQ8/jIAJNgppIqi8EGHnAqSCup1x4Lpni7DVYOmEbGiMj6O?=
 =?us-ascii?Q?PyYT1YocAKfoKlJHLXtnoRluT82sYoAE/c6t6w5mkLv+99CeNkBmkt1A5+0s?=
 =?us-ascii?Q?HrE8LsjXS+m40RENonhuXStDo/5QiqFzkt9+6PcKtpxF/zlzJydPPaZgZCGf?=
 =?us-ascii?Q?6AazPZfNeEv1sZ9uoxJGNsC3Wgk63B3mCBUCF2e/bOm8VZfkFwfCsImyC2hA?=
 =?us-ascii?Q?cPP1UsQoMF1ENmCJw1dUf+WqYuJqJSnW7zYt6UcPxZCWVr4Lj9uYQBjyr8hO?=
 =?us-ascii?Q?TfSA/s9fNqcL9H5eHKGm+UUVq65/q4nvVQ2HCd96nRyTuRIzML1dDKLHK2Or?=
 =?us-ascii?Q?8rcT6FM40ECLq/beQDlLgsotQREOKlmWlcd7VLzmY+xI0CjmrCxy81RyR32D?=
 =?us-ascii?Q?U1Skr13s725L6PwNrI6qi83brqJrJvahfTksU1Vb5h82WWH2wjhJ5WXg2iMY?=
 =?us-ascii?Q?2Go3yjgw6W2FQhhzg3qZlNa4A3KEAlHrVqhe/2+4SqF57bWmSx8o9efZ3V0t?=
 =?us-ascii?Q?Ay/uicd+0GVnZfkrgixuxbq0NDVHWHRjaxDtZbAUXtNEKl7TX22KeePpxpt4?=
 =?us-ascii?Q?AAue42Dflmodg677x/+6whYEwcWRf8ON43lkmgEvNcntytRST9DSzRI=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0AbvbPLBju+YgtQVCgPZkn+tsDEnpbdcEM9O+uDzVWp0fDtALK5zNp5w6HCp?=
 =?us-ascii?Q?CIfSFbE5uMrD1eR6XOB/x/IVEmRMSQpDPL7T46IEo2FncYjWk3R+dJwg5qQF?=
 =?us-ascii?Q?DTGqCTcYMdHOXqQWOseLR2LOmRPzTaOs72StWn5G+KAXmoHhapo5egIPZkB1?=
 =?us-ascii?Q?fR1kpePWNd6b/Te37OGHU00TWukfubC0nkwCMe0KXRWM4s9L3Vmq5CiB0vMH?=
 =?us-ascii?Q?3lhRtV+PmC6eJHmFZYGtbw6m+vGN1et0KCzNbZXHWt7GA9gzHQs3sFHYHrT/?=
 =?us-ascii?Q?TM5xqZHgdys0DLOpUh3Ed59dD6WqBIf02TPyb03QQpuXXyuwPaby5d1Jkof1?=
 =?us-ascii?Q?yN7FZC90HyIcm1oqt5GCLDlhm2kug7R+2RZoq/cl0KdhvD+ETC1+fv/zeG59?=
 =?us-ascii?Q?BszCAe+/W2JUT2qazZ/fVMQ6SSnzrQ48PzjKoXjWOzj8rUcrHTgq3eIIFRVh?=
 =?us-ascii?Q?MoaHth/hfTs6u4q3K2yGXeMDc01XI0w7xn1lkkG26jdkIPjBamK08iHONPp9?=
 =?us-ascii?Q?kzrwVxBPavstK8BseysAZZi+e4SHnSsIEVfEoa71mDe3drl9/c8amtet9YoA?=
 =?us-ascii?Q?eftyZhbZ5axRzmuW1+aBamG0v7SSDOYnfeQTdyXTXpC+ieGhTSVtI8T0FlGp?=
 =?us-ascii?Q?NKdSEVohQkGjq+kO+QCBIMrjyRp81wzKqUPO8H2cLBfHk4aFkFcEResG9g0p?=
 =?us-ascii?Q?FQ787r0WqhIpTClGOw9P7MoQ+4IIb+Ij3IQWdargGeDvQmO4fjUYtXdmVWZB?=
 =?us-ascii?Q?jkjQVR6n5v1y3ehh1VwJgZmIYOIQqooowC/WCrwbhX5Mv5lG6t8br2cySJno?=
 =?us-ascii?Q?6ovkwyBDfjUEPQB0PvKWc1n9yY0h0eAsPd7m2i6IlMKn20qyg3dCSbhtTy+O?=
 =?us-ascii?Q?3oPOqo6f7419GkZOkgfQE0mHf9KQU0XqknGcu4bK1EEj2nbf51vNB9dtB6x9?=
 =?us-ascii?Q?okIK08q57Gd/V08wkBtK8Jm3BNUB/Pl7xc6TPWqP7XoJdtvZ1DrmTn42Eqbx?=
 =?us-ascii?Q?TDpNTU4A/dLEDFqkr2izERm6ofGsX7uUA6ZWj4bSUsgr6TfF4FH88wPdDgtk?=
 =?us-ascii?Q?C+ZXSUPdJs6MQdy+dBRlM0frszATqytT8EeubtrOzoPESCbhQIMY5Zn42sbB?=
 =?us-ascii?Q?RCbcGF72cNlb+maM96CXU0uEiulTgE8P9fMA89e/lefqo6PLd27Yh0VjO2UN?=
 =?us-ascii?Q?3vGmmuvwhSAQgYjIJDc5+4YnrZx5rQqC0ebQMKkBcIp/U4lf454djv92VfcJ?=
 =?us-ascii?Q?Kk8YyALxM1XwFidiHcR6KiQVaOoL8JX5raDxKZe1NSPWci5DLJ34Xde/Pd4U?=
 =?us-ascii?Q?ANhoXUfu4qUimIvp7bNnAoTt9mzDetUi8UCCHdCruqIug+dTgqUxX/QAxJN5?=
 =?us-ascii?Q?gacBGWymxziG52RNQz5p7K2VnNhtTcDL6yOn/7UmRPfcq1kjgeKJ83vMfM7+?=
 =?us-ascii?Q?sYbFw95tIU3+gn8dwTRwW2etcKbtGSgS?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: f45a1970-e62c-419a-7a26-08df0ca09334
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 05:26:31.7257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVX0PF607FB09A8

The mwifiex_process_multi_chan_event() function uses grp_info->intf_num
from the firmware as a loop bound to index into the bss_type_numlist[]
flexible array member. However, intf_num is not validated against the
TLV data length (tlv_len), so a malicious USB device (or corrupted
firmware response) can set intf_num larger than the actual array entries
in the TLV, causing an out-of-bounds read past the TLV data.

Add a validation check to ensure that the TLV data is large enough to
contain intf_num entries in bss_type_numlist[].

Fixes: 2b0f997db43f ("mwifiex: add usb multi channel event process support")
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
---
 drivers/net/wireless/marvell/mwifiex/sta_event.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index fecd88967ceb..b17ff263489f 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -450,6 +450,9 @@ void mwifiex_process_multi_chan_event(struct mwifiex_private *priv,
 
 		grp_info = (struct mwifiex_ie_types_mc_group_info *)tlv;
 		intf_num = grp_info->intf_num;
+		if (tlv_len < sizeof(*grp_info) -
+			      sizeof(grp_info->header) + intf_num)
+			break;
 		for (i = 0; i < intf_num; i++) {
 			bss_type = grp_info->bss_type_numlist[i] >> 4;
 			bss_num = grp_info->bss_type_numlist[i] & BSS_NUM_MASK;
-- 
2.43.0

