Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazolkn19010021.outbound.protection.outlook.com [52.103.33.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95717346E58;
	Mon,  7 Sep 2026 04:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.33.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788756841; cv=fail; b=HqlXXvYlUOqeIy+jihhpLJQ36g6hGc9vBSPCoT0uwpktfiIsm5hA5pFqfP4ZBmreXWB3S9SJlu4LIsnQug2h50WN/UCETUX22a7hemy/wMU7GPS2/QecnB8/qZGOV+MUQB/QtJNCjVtPxr82LSza+v04d3q3FnfmOlcAde6Izoo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788756841; c=relaxed/simple;
	bh=HoJbcRLzPfHBdg9tyfaHU1RTqs08Nlq7VC4y/FvDLbM=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=eHxbVl55vh5+wvmm9Qk87VrTTpf3RZQORPQ67ZH9qh9zxdDDpAzTEEpdlIBqp5LSc9tzdcwFp1Cg0v4weCQzUmKLmbIfHlkuWbSjS5C46v/hzSA/Fnx9JteFVNEssjnavMvom6vkQUcQHyVOSlhS/ywZE7fzkbZjahTlXSEdP8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=QthGaufm; arc=fail smtp.client-ip=52.103.33.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="QthGaufm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LX/DLJ0BoicWRO0W5yKw601s1FercwQtZIMLE3gG2Ohvwo95g/cv6Ax09eIuySm+KbvhN0WCe2lP2HqO+DvVLXfAalV3TGfeeIIKn716Io5DGEr7WgJ8A6xH6CPOVsNgrtyYd8UdtCh4hO4JyiCQubXSrFNcle5X4LetFUNFo8AssB6WhYnlGRWb3j5HHqG/yJJmowVLgtgB4lIdG9f/IT9Q+E7B77hgt6da1W8ARv5vcRICznGndaC0lbOowdvqhCV8flrLsOmfwKa0unBGKZiXQoz5omtS01LHF8hpEgiS0J9ZL8baaX1VzWfvRJlqmhrZp59IbjnZLWiXtdRZfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rMyVWfIveMBbBwMujC+bpZDC9Fe+XF+etCfmCL1jUXA=;
 b=PQVItbtUWbwE9mhaAWIfO/ejYbCHLl8Bp6BWU6Qt8nkYzZ9/A4xNOk+x1r5SdZELC4PnIPRag2kCu9JeUNp5IEoOwqJN1wBdaTz8bam+oaooKTlDElXieh5ALzS51hwGuKLeKRUzsfvXzE4ey0r17xgOBDZL67jx47hrOxp2mJfm4ipt2qiMmArpmtVNbWTrwzb6YcrRQzP4uX2L+2PZyOJrMUpzyt8ookk2Gw6/vznXamEH3dpa39TMwCyAYi1o6vg30i/0f2KkF0is7qVvFj3mrbvLFLCSDNQtsILXiadkNP9PvBOuJdzlFnx/7V8RnlOQrFC7y6SebRME18vwYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMyVWfIveMBbBwMujC+bpZDC9Fe+XF+etCfmCL1jUXA=;
 b=QthGaufmKQjKkWc7MqPAXQ1RQZYDqg6HR5o1sIgMq4jO9K67h3tbQLJvtOxayhcQirSgFYCuQPfnHNKpwqyU95tLX7c4SLuHooayrp3VOtFrLDSauskPc77XHDV6gf0+7KuMqkZjCxmTptPx76SQgwrhj6gFAOYl60Ht82IZ3Mgo/2TOJD+VgzJPqwhlhATfHDNzZV3Z7gH/hv5BLM3uy5JhdOXzC+EyWB4epS/WhiUjZJeEL70som+lCYrp4XKBBRj6laHNeEHeSzR2P8d1X00cyicd0jeYLIExWhyqwOo43Du1ZxyNydIr2PEItzbTIPWsvBq8OhjH8jw8wsk6ZA==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by PA1P251MB1068.EURP251.PROD.OUTLOOK.COM (2603:10a6:102:45c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 04:53:57 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 04:53:57 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: briannorris@chromium.org,
	francesco@dolcini.it
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aamir Ahmed <elb12345@hotmail.co.uk>
Subject: [PATCH] wifi: mwifiex: validate TID in block ack response handlers
Date: Mon,  7 Sep 2026 04:53:54 +0000
Message-ID:
 <AS8P251MB0001FF491F88A38534EA3F86C8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0532.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2c5::14) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260907045354.542328-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|PA1P251MB1068:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d635ac3-c212-4c54-b935-08df0c9c0622
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5062599005|55001999006|41001999006|5072599009|25010399006|2604032031799003|19110799012|15080799012|23021999003|37011999003|25031999004|12121999013|8060799015|24021099003|51005399006|3412199025|440099028|26104999009|40105399003|2607281247196008|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gE5vRM6gT5ED53h9QmyrToesHOq72tG5amKm9c2ktpbTGKsLDsVuQ0waeeG2?=
 =?us-ascii?Q?cEVdsgGCW9Lvv7O28Lqq5VK1gDJT6CMJvESig8OiI2sOoxyRwTAEywviBDof?=
 =?us-ascii?Q?XHtfz8nYe12t9E3cUSZRd6hxDLCntVNlEaW7WBH3o2MStEEL6VoH7TCVFVtI?=
 =?us-ascii?Q?LVFeBK9+z5D2z42jd+0JcbY4bYNUZ4AI9q/yq+C/Lqel3a70JTkJ69m/0GvR?=
 =?us-ascii?Q?qUhB6qGvnvuKJu58PqUCIJZBUnP5+n2I+aejdK8m16ohXQY/1nby6ZLOyxWd?=
 =?us-ascii?Q?IEU3V+Lcx8LZRWDZbAeToN1Rq4smwcvandbyheEufQAmOkS8rWRwboFuwCji?=
 =?us-ascii?Q?dBum6Dr3ZcNndZ/XL9/MsymPXkRxF9fyQJLrKBvFi6OHA4ysCWYXT9hbIHpP?=
 =?us-ascii?Q?0XRfePb+loJ0/T0gv15fsoTeEnaHUHFEiZC1CmxAzeD/VF0wDLPfem3z0tgi?=
 =?us-ascii?Q?TchBjKFTzlkIAz86dAqDM/cENfzjqtp7FGLpWoY16GMW2QYQM63qfmVD+DUd?=
 =?us-ascii?Q?qSG0zT/6Ydi8PmRJiZomuhlVLaSPhCX0IkyTa6U0LYNZEzcyg/ZiLjItHS8Q?=
 =?us-ascii?Q?GZuf8KHsTuom9gfsSPFJSBL3Xk0Qy70ISnrmFVQbSJDnMld+u9nCPJ0CjCmA?=
 =?us-ascii?Q?P4dGpElT6KryRVmOWc1vQ0UISBv7SJ+mvkpHvsr5XWABLz9LLoDNCbjSQwoF?=
 =?us-ascii?Q?qRL5G2Ed5FjvUiOlNcNz4pB+jc+09P61U9fwDwRZqLMWuyxnO5BnGXsojB7m?=
 =?us-ascii?Q?T9ONAviWxhR8ZMZfhhRCyNNLDDRFceR/1696JnLZHOCPQnojGbJRQdqr5jDU?=
 =?us-ascii?Q?3EcgeYWzWuT7kpBXGRWP2+/akY8q5zTkaRtlH2g84uxdHTxAyLxMyuQUmwJX?=
 =?us-ascii?Q?OMe1RWbnHyjEzH3BKfcGndnpNh4yqiMX25nTYbQGJWA2uK2hLMLR5CQ5ft+p?=
 =?us-ascii?Q?f73bet3XQdC2KumhIaynaP8c40CXjE4Xzb3Xa2NTJCwtdDmsY3k8j8K9Duzx?=
 =?us-ascii?Q?sjAp3trrw6jvOJajmZj/SK+22oNWYU2RQR12j4FcSzow9eK6P1FPJ7ZnKxvJ?=
 =?us-ascii?Q?yb7hC8yz8o1mY8EbzwyoXbkMm7FfTe9/dJF7UX8OXav5PAfDjuborFft2EJ+?=
 =?us-ascii?Q?itUANOqPO4WiWESMyvsZNLD3BRjvRgOrAieFdmN3YdO9OZrdkcpgA8EC/8U9?=
 =?us-ascii?Q?kDlCykBxb2VdetVzRzSrtRLUyqo6DUCjQZmm2Q=3D=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vnrLHbZSoWCgnW19Kf0rh3JCKjp8ucZm3j6BusPovoVc5aj5AqXnF284jC1B?=
 =?us-ascii?Q?o4n/PzVK3PjDQLQjhOLucjga8DA8TfxEHw8AGKqitOCPQo38HQNPJPZpmRGG?=
 =?us-ascii?Q?O3iSMQbDdrsrVhZ7h8MbyuE/mUndUqMrWqS8LZTk03RlkLuMfxWyEEkGdar6?=
 =?us-ascii?Q?floIhBwRwc+IulImgkpqMvmc1pDlvSjL/zUcNJK+2XqAL5juoWj39FRyJNDX?=
 =?us-ascii?Q?xo/4lWtbO1mdG/YgVcV6ZMwCczxMM8C9cWmE8u6UuVjZ8pqsYYlCy6L98+nl?=
 =?us-ascii?Q?d8E2XZRz9Q2QSg9PhrvPAPo7jTQg+CDNKQKpn3qQeD/bmc90iHyapdPP46v+?=
 =?us-ascii?Q?PBZoN45Xux2IqVQ8VDi3A3V71fb4fQIYMPBzmVmyQ09ASQyJCGvoUqF+vfPX?=
 =?us-ascii?Q?dW2hY1biY/yB8jhSWXdhdrQvEvmInXyq5OwnC2DbpVPdLz6pv0ejmJ24vMax?=
 =?us-ascii?Q?5tAKjDWZVOYUluOOUwJt5RBfl0/nUisNB9tKj1a9zbF6UjBXc7LbM5MAtP+Y?=
 =?us-ascii?Q?ITQfbmRNbvGUi2dQXN+3lflLzKR38X7KqU5qsNen4Oskx9WzHq24iFGbnOVL?=
 =?us-ascii?Q?IACL4e/6HcBLA+N9EgUc7ZqX45q1lLC6m6Oi7YO+qzJkKx1XaCjRtznMyXUZ?=
 =?us-ascii?Q?UkCb/GGvkA+Tg7wn+GGdsVZD+wA3LQ6GcxHoAALkotVTXY9rmQgxKH0J85zx?=
 =?us-ascii?Q?RorHmpC5VUoRBVqpAlcXBlMAL2BS287p2N3K1Kc2+urWsADai44G945qiRK9?=
 =?us-ascii?Q?WVgrDQuEHYZ1jkoMONs6bYmy8S87R4SGViDcS6VKXK0e8PFQjgRGciLfVRPz?=
 =?us-ascii?Q?6sN1dGdoQmeiJPe6YbCOrj4neUSTer6vBdeExORiX51kxtyEpJNU+25si2QC?=
 =?us-ascii?Q?70/uoBB1zfQJeHWsQ3o0+RNgPKwIj+DqseTCBCqgjoOIuQ3VXYDgG7ykRBs9?=
 =?us-ascii?Q?tJG4d5qq9Y9X/xPnI0PSUHfz3YD+CgLIAhBzP5/W/yXuLIhHFA3dbQTjxLb3?=
 =?us-ascii?Q?jtzbKVxnNMbHo5P/UU0fHPEK510JKOt8q4igF4zOLqBevfewnDTosb0MiDae?=
 =?us-ascii?Q?68jpK/x1uOatw2eRyrBoCoqVch/02IzHMq0HisaAYLaQy+3nEGzHGLj7K6B7?=
 =?us-ascii?Q?rNB6UpG8PLdOCMwnfoLkpJj3AUVSdc3/NW+lYU+TQkMG7hLnNM1HGryLJtgb?=
 =?us-ascii?Q?3qYrGqVOZK4lmIIEF6arbZMZLivDYU1O1XiPJcjyNBgPTrxYHQ2FivZ2nAk4?=
 =?us-ascii?Q?FygYLS18u+5e1b08gmNgYFi6Hq/uuNi7Xz0TwlM0l8fghBfP+1K72R8hlao+?=
 =?us-ascii?Q?E7mi6PzOXJrVqrOn/rJUp4SLez56sbt1QsklO8MTPZGYYrqcuxc4ESue44eC?=
 =?us-ascii?Q?0hRRaO3kwFsBlHaX/fFC3VcbcBewNFGjKJBo87u2zqEPN8xPxvYyBnZk5rUz?=
 =?us-ascii?Q?Mbfjj595Od3qFxmC3+IOV/2mBLW9lZzH?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d635ac3-c212-4c54-b935-08df0c9c0622
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 04:53:57.0012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA1P251MB1068

The TID field in IEEE 802.11 Block Ack parameter sets is a 4-bit field
(bits 2-5 of IEEE80211_ADDBA_PARAM_TID_MASK = 0x003C), yielding values
0-15 when extracted. However, mwifiex only supports 8 TIDs
(MAX_NUM_TID = 8), and uses TID values to index the aggr_prio_tbl array.

A malicious USB device (or a crafted firmware response) can supply an
AddBA response with TID >= 8, causing out-of-bounds array accesses in:

  - mwifiex_ret_11n_addba_req(): OOB write to aggr_prio_tbl[tid].ampdu_ap
    and OOB read of aggr_prio_tbl[tid].amsdu

  - mwifiex_cmd_11n_addba_rsp_gen(): OOB read of
    aggr_prio_tbl[tid].amsdu

  - mwifiex_ret_11n_addba_resp(): OOB read of aggr_prio_tbl[tid].amsdu

Add bounds checks against MAX_NUM_TID immediately after extracting the
TID value from the block ack parameter set in all three functions.

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
---
 drivers/net/wireless/marvell/mwifiex/11n.c           | 2 ++
 drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n.c b/drivers/net/wireless/marvell/mwifiex/11n.c
index cef8a55427dd..82b1d35926c1 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n.c
@@ -153,6 +153,8 @@ int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 
 	tid = (block_ack_param_set & IEEE80211_ADDBA_PARAM_TID_MASK)
 	       >> BLOCKACKPARAM_TID_POS;
+	if (tid >= MAX_NUM_TID)
+		return -1;
 
 	tid_down = mwifiex_wmm_downgrade_tid(priv, tid);
 	ra_list = mwifiex_wmm_get_ralist_node(priv, tid_down, add_ba_rsp->
diff --git a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
index 9deb47f22a61..80fafe08b6dc 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
@@ -492,6 +492,8 @@ int mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
 	block_ack_param_set = le16_to_cpu(cmd_addba_req->block_ack_param_set);
 	tid = (block_ack_param_set & IEEE80211_ADDBA_PARAM_TID_MASK)
 		>> BLOCKACKPARAM_TID_POS;
+	if (tid >= MAX_NUM_TID)
+		return -1;
 	add_ba_rsp->status_code = cpu_to_le16(ADDBA_RSP_STATUS_ACCEPT);
 	block_ack_param_set &= ~IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK;
 
@@ -721,6 +723,8 @@ int mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
 
 	tid = (block_ack_param_set & IEEE80211_ADDBA_PARAM_TID_MASK)
 		>> BLOCKACKPARAM_TID_POS;
+	if (tid >= MAX_NUM_TID)
+		return -1;
 	/*
 	 * Check if we had rejected the ADDBA, if yes then do not create
 	 * the stream
-- 
2.43.0

