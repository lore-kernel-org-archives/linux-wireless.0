Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazolkn19012010.outbound.protection.outlook.com [52.103.32.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD9232B123;
	Sat, 12 Sep 2026 13:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.32.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220885; cv=fail; b=Ydz2YEvJVjXDuO0aUTV9UnP52fey6xmMJUP099BY8sLkGQN77F8pkq6z61eju6RC0kkkW0jjXwJIRQp6q1ODhy971gU7NoHXbppXLodfJVjL5zgrY863pFu5gaMVHZ4A9QAqONzStqEFmm27H3v9id+d0oI0st0HdGA4SgajEIY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220885; c=relaxed/simple;
	bh=6F4k1Cg3tDBX9jOW6ofLeAQETmmkjI1n/DgqkbLeYBw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=TFZ3lUAsMFKxy2YMl8hEnE69sHYsIXTcXr35BHJGFX63/D95+2wJcDnO7ujuIeRVHDRpVVXM+QUPugq3WnQyygwNitrPoCqhJ3e2UOmsvKdpKIGhCbIIes9sMgheruIe3et3LWM+QHg9UiVfb09DKzbItfTZspP/UXkiw8RONJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=CVcNesNM; arc=fail smtp.client-ip=52.103.32.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="CVcNesNM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hVc3YIxs3E2Itf5apU2EuWNlx8pTr5at4dyn8gX2IFSgJKjuUspArsHBTyd+vqjkW0k1W0kZSCZxW5u49hl2/uXrr7R8E/vDeqEVK8qsYCVdLbZ5vv9IX6fnM0kEzxUxmXJBJJBNs5oKa2AnVc8TqESnE8YSmHGyPX3RFNfimjc2ExS+HJStCBvWVtOTYj6bTwEqAHLLOKm1T8NJHKm3Otcikqw9g3qU48ajL8g+vPA1D0xPbBmKgjJOugCBwnwPU82EQNeFMamMSWtZedgauZA2StiL+Yeb9Wk8h/VNu5ie+bRqryQlYp9VvWkckmAPfA+yv6j+buwigUDv9TUh7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ioWtLs9+HsCAcTvbY62DQPZD4rLFmsW031P0pSD1qi8=;
 b=Y+FjpM4rci9EzVu9cIBBkxJn4oM2bQ4tKXj8fkU/905voDS/osytD4HbnHj0+puOlXMsUpvDmnhWpTyj9FJr0fZcoIxA4YOM9aywq4xDc1BUPoC+pQN+OzROLuwAuX5QVt5mleYYUvhjT9Zo7AW6oQDLPbiNcPz04Uik6DX4gzY2Zm4o+pnl0vXBDaEQuSncTDFbNSaRZ7H9lwPCmiHp8HLIN5a9rRjHIxJIxkH54549XUweDhZhdvgZjODBSf+Ncch9KVa1fybKLulUaWwOxDTt0s2/NNQGoGnxV99XLQ1+dt5qfj/Gbh3cj54Rm/sMC38Dv39amLO06IhS4x72Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ioWtLs9+HsCAcTvbY62DQPZD4rLFmsW031P0pSD1qi8=;
 b=CVcNesNMrXUEWdYNx/MYA7bvyLZ9GtahOvGjnOXwtkGepGwf9RUEfV0+0dFvonc4EZwSFT+DOacYj32KWMevnrkeBt2xoXj/Zflc1JYR+KUizOXuAJBEe5F6HVyD2LGWBeOC2u9CaPKVChM0QJKBIKmdD32uAzuWPmpKjItIMBG65cd9pX6pdNcg93wjCLaNrluZgrKVwqJQWOuUDwPx48y+BEJN8CRtI/9GZeP3YefUvSMqe9+0h9aqSxT2Ln7OIxdG68fxXNTHzBmEHBIEafMIpOj5mrFumQ6eJUOsvP6KBizXRlcTBU6qayLhgX/svWilFqPvLybQrq3OsYobDQ==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by AS4P251MB0512.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:4b7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.11; Sat, 12 Sep
 2026 13:47:57 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%3]) with mapi id 15.21.0406.007; Sat, 12 Sep 2026
 13:47:57 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: jerome.pouiller@silabs.com,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH wireless v2] wifi: wfx: validate MIB read length before copying to caller
Date: Sat, 12 Sep 2026 14:47:55 +0100
Message-ID:
 <AS8P251MB000155034FC391A2A54B9803C8BD2@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.55.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0378.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::23) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260912134755.18621-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|AS4P251MB0512:EE_
X-MS-Office365-Filtering-Correlation-Id: 663eae5b-9d31-4187-9233-08df10d473dd
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|41001999006|5072599009|6090799003|8060799015|19110799012|5062599005|51005399006|55001999006|24021099003|15080799012|37011999003|25010399006|23021999003|25031999004|12121999013|4302099013|3412199025|26104999009|440099028|2607281247196008|40105399003|1602099012|10035399007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Tk05b0o4RFlIQUZlWTR3M0VNMHRES091dC9NME9ZbitVZ01mZm4zOWdia0Yr?=
 =?utf-8?B?NUxPdEJGZlJ4cU9TcVFjSk10dTZJRDIyMVlxZHNYOTRSWnVRV2poR3ZLdHgy?=
 =?utf-8?B?Ym1hZ1JudmZsdC9sVWd2OWgyaHBIQ2NBQnNBc29BTHlZcmcxSWE4eVcxWVBO?=
 =?utf-8?B?cXdobTc1Sk5GVXIxN1RaNmd5ZzRDSFF5TW9FdkdjcS9FdEJvRk9qVzYvRjhG?=
 =?utf-8?B?cXJZS3Y1c3JWWTB2YmMwVnk5ODZ3eDhRNVNzKzlZckVwWHM1ckUxcEdaM2FQ?=
 =?utf-8?B?SXdoazhsOERaRUp5aHFmeGtnQWJqSUJZaFJkSm5pUVI3bnFGQ1l2enQ1QlRQ?=
 =?utf-8?B?MWhtU2lyY1ZTR0k1NG8vemVDTEo5MzltVkxlRElrKzMrUjNTN3J1UjJqM3Ru?=
 =?utf-8?B?WldEWmkydmdQcTVtUVREOURpcGVHWC9CSS9wUEYwK2M2SGJRZUtUQzlFRkxw?=
 =?utf-8?B?NnFxMHNWU3RISU5tc0swZU5NYzBYWUFJb3o1WlBYdG92bDIxU3BmNzRTSDFl?=
 =?utf-8?B?OFFVaGI0aEJpMDFQOVoyL2IyRGwxODB0U2xZS0Nxd28xM1I4MnlCeVNQTjJW?=
 =?utf-8?B?R1JUSmd6N2NzamM4blRhZjEyWldublU0V1RqYkFHdmRIYWg2Q3BLbGMyUzZB?=
 =?utf-8?B?UERPUXJxWllHVWY0NW8ySXFzMnhaOURHdm5OUTFBRzNSZk93N1FjNmFJaWwx?=
 =?utf-8?B?eDVwUjUzR1RPYkJJbmI4dDFJNC9Hbks2Mm5oSFZxaEF0aEN1TGttTUQ5bjJN?=
 =?utf-8?B?TTdqa0xLOTZOdkR6akp1NGpRV2Y1bmdVWkx3YlRwZ3lVbk95d29icDJPb0tM?=
 =?utf-8?B?VUxiYzA1QXdVa1ZWZmFMNmZSeG9oNlIvT1Q0NFVIWU9mRksrL0xhUWpqbnpG?=
 =?utf-8?B?VjRQOVFqMFBmcW53N2JVWmxjQm9iWHdIeWpPbXJUcG50UGp1cFZEWmNmWERX?=
 =?utf-8?B?SktpRXpHSEh6YS9pblZ3TlFnamtTRGd6ditLdGloL3lUa0hkM2FreC9XazhX?=
 =?utf-8?B?Z2lyeFZmb3E2WWs0N24yRkRoVmNEREQ0UHBTbDNsZVp1ckFjUnJwSmtLSlhn?=
 =?utf-8?B?Mk5Va21PY29hVkNJYmVKN3ppT2t3Tk15STc0d1MrNFlHVzZwNnNYTEtSYjQ2?=
 =?utf-8?B?S0ZIeHdRZ2NPQnRoUVRIc2wyRjFnN0cvU3Vpc0J4akZPeENJamNxbVdaazJJ?=
 =?utf-8?B?YkN5V09iRFhWcDZCZVlDK1BIelBRNCtPanJHSncvKzN5UjhWVU5CL3BHc0tB?=
 =?utf-8?B?N3ozK1FiN1orWSt2ZmlxRVh0Szk1RWdOcXlJUGRNb2ZrTzBIVThnMnlJcG1K?=
 =?utf-8?B?MlFvWUg1MDh0dC9sdDVGdS9RL1BZQWIwbFhlanp3R0dEYkxtQ0Jna1JzZDRo?=
 =?utf-8?B?NlVNbW1pTHFqRTU0c0tiWkJiT0duZk1jdjFZSmZKTkRxbVpqZmhZNVgrWEIx?=
 =?utf-8?B?dkl6OGh0UHhmTC94S0Z1VTRGeW4wTkF1dGFoQ2lkVllsN0JWQWN0ZFNQZGtM?=
 =?utf-8?B?b0tzWE5RTjdNSFhVQzdGdjRDQjRNSndyM3pzY2FBMkVGRzB0MllGcGg3SkpI?=
 =?utf-8?B?SktnaEFXV1NEZnk2RnBFVFlzMGpzbjlBTFg4YUtzOEZydVFLV3BtWCtMYmVL?=
 =?utf-8?B?ZFdaUmx6WitKWlAzK1prOXRnd3I1cVJFZm9XNHRNRmRacjV3eEV0a1FXVnAy?=
 =?utf-8?Q?Tg5PwqObXPvGre7tm3Xi?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Nll1MlMzYUMwQzVVaHMrMUNjWjFpTkR0MzZZQlR2dUpFa1RSN0FTbmtJOTc0?=
 =?utf-8?B?ZTZDY2s1djFhdGVQRThHUVpUMnV6cUU5TXNEcnpScG1JSkJyV2RQWDUwYnh5?=
 =?utf-8?B?L1R6bDNoZ0M3bkU2dFpWU2N6aVUycXQxWHBWVU9VZXUzRDMwZ0ozRWtMV1Mz?=
 =?utf-8?B?Mnc0a01QTHA0M1FkeVJJalk1WlFlVUVnc3RzK1cwTFZ0SlR3NlN6V1QyTmxD?=
 =?utf-8?B?U29rc01FRllaNTNEUUdWRk5aMmtjQkFIMDZnbUtlSDhsQUJCWkRON3VxWmdN?=
 =?utf-8?B?STNoOUxCaEJ3MTh6cndCMllxT1FtdUNHUVgrMjREak00bmZ1NDYzN2tkTmhp?=
 =?utf-8?B?aDE2Qkd4czZscTZzVVdYdXFTOURidHN0WENENHJPRmRHMndHUGVMeDA4MEtU?=
 =?utf-8?B?N2QwRUd6Njd1TUltRkQwTy91RXdjZTJ3b3MwMW5LMThucGh6RlVKR2lDaSs2?=
 =?utf-8?B?aENzYmdXMU13VXp4MC9tanRrV1BOMG0yUE9MbE5yVC9TdG5xN1JNR1ZqeUY2?=
 =?utf-8?B?dDAraHdXTnJ2QXd4MmluL25uUjE4bGhqT3NTZFZ2MitydzZaMkEyTGptZHJu?=
 =?utf-8?B?c1ZkY1E5VGFqZ1BDSTBWTEpxS2pTdFE2cTVONGFIUG1XaENFaENyTi9oMFBo?=
 =?utf-8?B?eXJzRFNCL3BpQXp0VzlIazdENUJ6aW5aVGRsaUJtcXBLR0dSU0tUZzZITHJt?=
 =?utf-8?B?V0FleDdHbjBJUmFqRS92TC9SZkovRXZWcnFHMHBMV3ZQUmliMUpaRDJEQXZv?=
 =?utf-8?B?YjRUUS9BNlg4cUNYbHR6MXQrdWpDckFDeGZlQ09OWmRTYVVjb0NqaGJadnYr?=
 =?utf-8?B?WHJlaHdabEw1M2NUTEFsUUt1Um01SUsvYlRubUdoTEFKdTlpa2diZFV6RW04?=
 =?utf-8?B?YXdYbndyM2dzZEpaRVVvNkovTFhnYXdZWVhrNEt4VTI5dFNaZDdRcjlSb1Jt?=
 =?utf-8?B?dWJHWGJ6UkdQZGo3WVd3R3htZHVQZnBmQnVvWkFWWS8vbVppYk9pWDVnalJo?=
 =?utf-8?B?dU5waTZ4UWM0eEZDT24rajdZbnlDaWlpZFcvMmt2RVlTVUo3VkdNVWp0bS91?=
 =?utf-8?B?SDR4bGxQZTVoMTZJMkExUHRlWUlvREdPSkFienN1cEhqVFcyNEx1UXIxNkF3?=
 =?utf-8?B?VmFoR1RQRXErK2xiRFpVbVd6bnVqRjNKQTFNajRmSjhJWERBWjlEMlBFVUR0?=
 =?utf-8?B?ajJ0eE9ZaTJwNW1ybTdXSXRIRnBrK01GUmlPN3psZWxQQktBSjJLU2VCVVQ4?=
 =?utf-8?B?K3dRVUw3aTJKRGhWV3R2Zm9PaGJkMmVoUjlua2YrczZzdFRBWDlQNmpYTno5?=
 =?utf-8?B?TGdSMjJubmpURitGM2IvKzN1WUFUaVk1bjFZK2NpOEI4cDl1TmdXeU4yUkQ4?=
 =?utf-8?B?RXNqUUl5alQ2VElHbkxoL2g2MS9vTFJQaDFtczZmZTMxekJzZmVJSGl6djdi?=
 =?utf-8?B?T1habUF6ZVcxMUFEak5EY2lKWWhxZGRQbE5yeGtzendER3ZZZjBVVkE1UmZQ?=
 =?utf-8?B?ekhPeGw0ZnZIbzBHeE9EaVNtMThiVjl3QjFOOSszTVBpREdZT2tOU0xqQmRJ?=
 =?utf-8?B?aEVSd2FJblJuL3FYUm0vSldkMmtVZW96NS9ta3h5MElndGZ6aHBNd2JTZ1pG?=
 =?utf-8?B?Uk5MdG9aNEM5amxiQ2IxUmVxQUxGZlRNMmVJQ3IwOHRBdStOUHZodHB6MFBS?=
 =?utf-8?B?WFQxSVllVWZlbGNqVGx4bXc1bjdTUDY5MjlSalJLUGw3ZEc4Ynl3MmdmUWZq?=
 =?utf-8?B?cFNyZzdxVGU2anU1M2tCaGUxc3NoOFpBQWQ3bTl1cGRvQUtjYVlQQmIzdkdD?=
 =?utf-8?B?RTEyWDJWN25TWEtYNGF5WGxYa0VCTUM4UUpXZktIOUVnWnNZcHZxM2NXOXVJ?=
 =?utf-8?B?VTdvUGdISjRZdG1yWjUyL3hoMGVISzkyMjdQWkpGOERjbm83VXJqcUxNS0Z4?=
 =?utf-8?Q?E0tA2REfNJ4R/cMrwht9CiOCei9hyl0w?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 663eae5b-9d31-4187-9233-08df10d473dd
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2026 13:47:57.5822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4P251MB0512

wfx_hif_read_mib() copies reply->length bytes from the firmware
response into the caller-provided buffer without checking that
reply->length does not exceed val_len. A firmware response with
a length field larger than expected overruns the caller buffer and
reads past the end of the reply allocation.

Replace the dead -ENOMEM check with an active validation that
reply->length fits within val_len before the memcpy.

Fixes: f95a29d40782 ("staging: wfx: add HIF commands helpers")
Assisted-by: LLM
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
---
v2:
  - return -EIO rather than -EINVAL, for consistency with the
    confirmation-mismatch path above (Jérôme)
  - add the Assisted-by: LLM tag (Jérôme)
  - Cc LKML (Jérôme)
  - correct the Fixes: tag; wfx_hif_read_mib() came in with
    f95a29d40782, not the TX-frames commit v1 pointed at
  - say what is actually overrun; v1 called it a heap overflow, but
    the caller buffer is overrun and the reply allocation over-read
  - name the target tree in the subject
v1: https://lore.kernel.org/linux-wireless/AS8P251MB00014841C19595C74C545C80C8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM/

Compile-tested only; I have no WFxxx hardware.

 drivers/net/wireless/silabs/wfx/hif_tx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/silabs/wfx/hif_tx.c b/drivers/net/wireless/silabs/wfx/hif_tx.c
index 9f403d275cb1..9efb108bd877 100644
--- a/drivers/net/wireless/silabs/wfx/hif_tx.c
+++ b/drivers/net/wireless/silabs/wfx/hif_tx.c
@@ -207,9 +207,11 @@ int wfx_hif_read_mib(struct wfx_dev *wdev, int vif_id, u16 mib_id, void *val, si
 		dev_warn(wdev->dev, "%s: confirmation mismatch request\n", __func__);
 		ret = -EIO;
 	}
-	if (ret == -ENOMEM)
+	if (!ret && le16_to_cpu(reply->length) > val_len) {
 		dev_err(wdev->dev, "buffer is too small to receive %s (%zu < %d)\n",
 			wfx_get_mib_name(mib_id), val_len, le16_to_cpu(reply->length));
+		ret = -EIO;
+	}
 	if (!ret)
 		memcpy(val, &reply->mib_data, le16_to_cpu(reply->length));
 	else

base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
2.55.0

