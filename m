Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012049.outbound.protection.outlook.com [40.107.75.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2371515A864;
	Thu, 16 Jul 2026 03:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784171789; cv=fail; b=dIWdX5QHIkFdo8T7xewfD7njTS659jiUnGJGCZHuX4a0pINcG8CGu+VrF8Tx6KnQAxTmBjDUu+EI9guj7DVFETrT0gxWo3MJdXvCn+cZpPZyrwcY9HXsXceXMPrFZR/37YI9zBLLQwCabi8acjXOjgXqyuFb5t9rkTuo+tdbtLo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784171789; c=relaxed/simple;
	bh=lkqYWbvRWwatnalxo/CTXdF43jeSBuXZSVQzRUlSe14=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=JJqR33rG92JdNsCDcWk06XuiB2sLsydCIWJ2RW+xnwmtVTtnOydtpjay9YMLjYh/cWogd2qr0U9knv+2Ab59ThUbGlyq67H+vtC3PGms4m1o1RkqwVfyym9tmzWjo88M89PXzh5jqnxKXTnnFIQ/bhjcJ/MUQRqR3H3G/rihvOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=qc3y0ZYB; arc=fail smtp.client-ip=40.107.75.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="qc3y0ZYB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mJhIwf2oyXORZOakafaEROZEIONpcqBMIi/ihQAN6hSgnv8XH6J/0cxPgC0tBWKgZnYKYTF2mFNp01Bg6AoLc6cuicP9fEduIP2jCQ8jvIMll9p+hpbJXiZlQu/CNdoY4JyalCPweC1mRTS9oVLdoCM6xFz+5Rxzjiy95hBVM9Z7ZI9xcoHGn9t6pDnwhtJwBNitGHt3v8RKgPUCaWKbrMOzSgP3KKav7f6tb51JNrazaLYZQJoze8wB6FozaGRb+TRijPWJ5bjPBIZ65ktzOhkzHyevbSgqQsi8B+iRre0TAl0M57dxsR0Hc0Mzk6ak06CySuidGXuHh4cV+UbzEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KUzoTqNzR+DVJgi2RwF2dr0K8QBgwfFSPRHb0ogLoBQ=;
 b=KVTGINQZsrkX8GlW9u4faIQm5yPUSq57o+3msNdKObYHX1j7bqwdsiBgQE+5JLGYQ2nxPfDIX+9HWrB9UWYhHLgyEKiNfZdbKtAVHw4weCEUHt5VLDf45XVpAORQhQq7IpzP/x8HNEiRIiEdEkjPL76Bx0RVU+9y0FYk8PG/IQf8sbFLam2Co1DOrjDV6M0Q1IDq0weqbalAOdwi9bNhvKc0QZcSD/qVmDzpz4AyXhHEPFNUKAyccvAwG+5PBbOvotu+jpvpU6FjaDqVHJDrmkFZyCUX+i2RIzbtPoY1hRGKcFuDzb01/7JEpwxTqFOAzYxDTlxecegITkfj3gUXzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUzoTqNzR+DVJgi2RwF2dr0K8QBgwfFSPRHb0ogLoBQ=;
 b=qc3y0ZYBCkEuw+AZHOShJGx7RxLoFu4PH0t5lgD4zFDpTX0MpgLlGOzPIul/Iv8V4rXXzlfi3xaQDeRq96qyFloWL1zGu6E9OuOCpA63p8i9LJiii79WPG9OyKdL5W/WQN332VxyPOzx2Ya2cQhD3MMnTGnhheK7DpgemRzY6FOQe2ITsVlzGcq8Xvdw7HKaWOe0m+shglgiMfYjMg4bSWejrYT3WTZyg+y9pcCFrBx79RfPQPqMZR3LoXX3upUYqob9AHuAWQ+4udFmQjLMm5dB3oWK0lpEtMuideyxEmNy2yucyTqR0PXmnt1sUqYwo52g1Z7WzRss0VbxyyQw+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com (2603:1096:101:c8::12)
 by SEYPR06MB5915.apcprd06.prod.outlook.com (2603:1096:101:dc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Thu, 16 Jul
 2026 03:16:20 +0000
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b]) by SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b%6]) with mapi id 15.21.0223.011; Thu, 16 Jul 2026
 03:16:20 +0000
From: Pan Chuang <panchuang@vivo.com>
To: Mark Greer <mgreer@animalcreek.com>,
	David Heidelberg <david@ixit.cz>,
	linux-wireless@vger.kernel.org (open list:TI TRF7970A NFC DRIVER),
	oe-linux-nfc@lists.linux.dev (open list:NFC SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Cc: Pan Chuang <panchuang@vivo.com>
Subject: [PATCH] NFC: trf7970a: Remove redundant dev_err()
Date: Thu, 16 Jul 2026 11:16:08 +0800
Message-Id: <20260716031608.137119-1-panchuang@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0015.APCP153.PROD.OUTLOOK.COM (2603:1096::25) To
 SEZPR06MB5832.apcprd06.prod.outlook.com (2603:1096:101:c8::12)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5832:EE_|SEYPR06MB5915:EE_
X-MS-Office365-Filtering-Correlation-Id: fc1a2099-28da-436c-88ad-08dee2e89b12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|52116014|23010399003|11063799006|56012099006|6133799003|18002099003|10067099003|38350700014;
X-Microsoft-Antispam-Message-Info:
	ZBVh/jJyO4I/kbqliX0dXPIOkEt8Hl3/ozEX1NBEUObYOXMfpDQVcl9alyG/ae3RB4TQ01SQ16tEcLKEHWsqdvZh80SnZzv2YBJkyTmxj49dsRHs8ynKjIfAne3EKA1GuKI63wXFwzWaMwtiYouGZdMFeyMnPRRRqPzJKD1lCn3mZXitd9086URJi19BWI1WGPVqKvdcYWRiUUCL7HYCkQnsvaUt+rnJwXIHA17Av0LoN/t+/C2XHPxCkB5A9Dl8Lq8x63DcfCX7NKonTbi4ROtoD1e4dQRdxvTD9y3T1quONvvkqNdfQleqFRhntNG+9rEAnT6MGYxN802WW5n2xX8NK8qUQ6vqualMgMIKZO+n032gMC4TVLxl3Xd/TN1Aow+U1IJXlA+Kd6Ca8qz7Wq4KD0jg57oMLpwZEPH3AYo34DaenanisV1gnbLucDiLnt2NQi5zlMAZjZfuUcXIPUg3DfFkSnrqme0cyWq1xBAgaT5jEbaCyqKdqu4bP0BKYD2+g+F1ZaJ8i5fvM0eOjMam0OTDNCyjTQd0ZG8HIzR/v9ii7ve32hICcG2bMDhPGYDmgWElFRqqtsfuZPHBJYCxHbQZxoSokqbnsEm5txQOkLBN92giMeOasg4NTYI/BynNaPCMgJsLF1AcrZs0fDLbVOohcOhpEmuAKLIJ48vUdP9N872THeC7lV8GMETa4NHuNRZaU0Tb05JMjQD6r97u5QjQK0Ly13SQg4i72zg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5832.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(52116014)(23010399003)(11063799006)(56012099006)(6133799003)(18002099003)(10067099003)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MgmnpmybMp88ypyvOvNnyYCdyVvKmkKUd+hYPwfLN6C02zb/sFomsUZEerkN?=
 =?us-ascii?Q?ndsDiVwn4Nk6MTyrD0I+A1D+nYHDUcFlhkX7cgQI7XsaDALX906UYf4IYWxR?=
 =?us-ascii?Q?ihAZlJAEZMdpsFellXUFFpMCBi/03gPORVolM9QGebzjPKhy7nxuUYgGl5c0?=
 =?us-ascii?Q?vBAsBcfG55H6vD1MCQjNI29GS/H7Hx5uoqj1Blmb2LoySM8QkYzBgKUsqbHR?=
 =?us-ascii?Q?WTmI0Q9yliGU42vNeQnyOQMULL+c3F/HAJZWFT93lzvw2IhBmJ7QUuoLSdR9?=
 =?us-ascii?Q?S+tSseJaBXbKjBH/uSNFwg3QTAus5W27NH0Ky/FJecdsYxYHsfl6ja1g2KKB?=
 =?us-ascii?Q?P0JpLttj9Tvs/LcPqFWtPM1LW2u507BBNKh/+ha5md5i9/nwkytpO0VEc+6U?=
 =?us-ascii?Q?ykXrMfmrVzulL6MUaNqLvQ6tTbuNs8ZlKMvtX5NgrWbzxCeOpRwrQdrF18vQ?=
 =?us-ascii?Q?Xd3OnONONkIGf/MiReLO+kI1L2aQ9mm9svAcSQBQis0rl9oKhFSDHQkUOCI/?=
 =?us-ascii?Q?5oEr8jAsoEz945ZcDpe9qdxHSvnWfhgbqko9O8FacQLIoazNXt/xwXelDyW2?=
 =?us-ascii?Q?mcEBPY3XslPO5NkpytFbhKEdVIhjd364jJKFnfU6yFRLPjNDOMULcTB7vGaf?=
 =?us-ascii?Q?m0uQW78FF8Dzcr4mGmg6PNIWGTwmuPjeBmqOOZM48eQVl/mrlpR5B+SlIDDC?=
 =?us-ascii?Q?2da3gsE7qHtGK41qlVA+0uXGov6O+NF+5EqnTzDZJSiv+wuXf261x2N8/Y9K?=
 =?us-ascii?Q?rNIic857kB1Djex55o2T4SmZO0767Fa29msw7tFduOgqggVp1+yvYE5tUXfC?=
 =?us-ascii?Q?gZmAYkbuXAUuYoR4BsmPRZ+xFjenP5QX7x9H3FQQcXVm/oNSDBIafRp6nWvc?=
 =?us-ascii?Q?hCbrz608dsW/or6gf0/BloQ7qGh9fGoJ7zqAkCKoypiHjfUpmnQMtGBSdGQJ?=
 =?us-ascii?Q?FRKM+Vdz/UcyAPeDxi77O8S4rTqmdUcdQ8PsTRkoy6Gx2bPLcvfxvyW32kIz?=
 =?us-ascii?Q?dj372KVhwK5eAf8beKP82Rl3FfTjtWZ2BRjOE/uO9IINkwFNrlX+QIuW2Sma?=
 =?us-ascii?Q?75hpHbukCbwT9ATRWdoQllyMkgxs+rhhDwh/e9UAU5u6hdSE3LKHATl7SaS6?=
 =?us-ascii?Q?zaxY7Q8Bw046f9hziedlcNVOnm30l17IV1Bo1oZ2qvuzlTADy6sdEHOTbraU?=
 =?us-ascii?Q?YUM8bz2tnTs1+wJ9BLo3u2kaeJo9gQv8B0bP/aKswKrszunBsYrrZ9feCmPo?=
 =?us-ascii?Q?3XhGy7fIbzixwq/KxpwqB5diR1i2JZqsUXRe//QOR4tmsoirxTpMnMBA44OC?=
 =?us-ascii?Q?T8yxn07PfRm7OfR266OAGsbISJbPW3k+wflG0KELNfqSklZnMgi5O+Uwopb3?=
 =?us-ascii?Q?RFfaRyp9RtNnM6at9DuHCMAxiZZKKXIh9J3LNqJVlNjAuqSsV9xjWzSAJiSw?=
 =?us-ascii?Q?4X0fGiYOHF2wcw1y+A1o0VuCIgGGnXgffAC3HP7GnC49leE+EMoDLIpOLCLU?=
 =?us-ascii?Q?QiYr/mj898m3o8rknbqZdw7NnP3cEWmZJ3dqCQrpFXRmFFpmiTYqBJGP5pyS?=
 =?us-ascii?Q?GmfBtSmA2NRCHDN7K+o+9QNo9UxdvBMmOm0Uv293K+YkMHXm6jn0x4LBl8+T?=
 =?us-ascii?Q?s+cbwnIWrzYV58HhBaJzfiLEAFlVY0vhbgR0WTkglhfflrHRxl28oB1Kr1pH?=
 =?us-ascii?Q?ACoHvBPyAWQhWYMksUX//oOk++SvZA1+HcbrketNGVaZnJ+ZMJnUkRwYbkLu?=
 =?us-ascii?Q?O/qQf2nx/Q=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc1a2099-28da-436c-88ad-08dee2e89b12
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5832.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 03:16:19.7413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WyMh/YtHSSN3Btw+o1k6oMqaRyqNJVpdpu0XmgXtrnakB9UgVf2a12EzhCGa7IEakPxCIDqwIC5nBuGbBsrXFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB5915

Since commit 55b48e23f5c4 ("genirq/devres: Add error handling in
devm_request_*_irq()"), devm_request_threaded_irq() automatically logs
detailed error messages on failure. Remove the now-redundant
driver-specific dev_err() calls.

Signed-off-by: Pan Chuang <panchuang@vivo.com>
---
 drivers/nfc/trf7970a.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index f22e091019de..277483b7a110 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -2128,10 +2128,8 @@ static int trf7970a_probe(struct spi_device *spi)
 					trf7970a_irq,
 					IRQF_TRIGGER_RISING | IRQF_ONESHOT,
 					"trf7970a", trf);
-	if (ret) {
-		dev_err(trf->dev, "Can't request IRQ#%d: %d\n", spi->irq, ret);
+	if (ret)
 		return ret;
-	}
 
 	mutex_init(&trf->lock);
 	INIT_DELAYED_WORK(&trf->timeout_work, trf7970a_timeout_work_handler);
-- 
2.34.1

