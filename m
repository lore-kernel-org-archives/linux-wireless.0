Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 064EBC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 18:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD42A20651
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 18:34:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=bowerswilkins.com header.i=@bowerswilkins.com header.b="tHj70jbb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391698AbfC0Seg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:34:36 -0400
Received: from mail-eopbgr80045.outbound.protection.outlook.com ([40.107.8.45]:1248
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391495AbfC0See (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 14:34:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bowerswilkins.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjOKeSepVR0PgfuqP4cwrNtxLeJZBB8I83t3cDetHK8=;
 b=tHj70jbbj0JXDw2B69W8OBbBi4r3VTECsKXTax4zNAb/GtkRncAQ5iTyTjDCwqeiFLcnFX/XkaD/KjedUgR2MJNU0/WbeN87a4hMgvUDooct9EKv+2qgZGiLe3MEUwlAtQA3ewJ81RRVkrxoeG+5Rx1lH+t2xLOyi3Qnk+aDCxo=
Received: from AM0PR04MB6065.eurprd04.prod.outlook.com (20.179.32.150) by
 AM0PR04MB5793.eurprd04.prod.outlook.com (20.178.118.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.18; Wed, 27 Mar 2019 18:34:30 +0000
Received: from AM0PR04MB6065.eurprd04.prod.outlook.com
 ([fe80::d0ea:9bdf:7139:b472]) by AM0PR04MB6065.eurprd04.prod.outlook.com
 ([fe80::d0ea:9bdf:7139:b472%6]) with mapi id 15.20.1730.019; Wed, 27 Mar 2019
 18:34:30 +0000
From:   Peter Oh <peter.oh@bowerswilkins.com>
To:     "wireless-regdb@lists.infradead.org" 
        <wireless-regdb@lists.infradead.org>
CC:     Peter Oh <peter.oh@bowerswilkins.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless-regdb: Update regulatory rules for South Korea
Thread-Topic: [PATCH] wireless-regdb: Update regulatory rules for South Korea
Thread-Index: AQHU5Mu2uUa12PzgWkyvey1kbLHWEg==
Date:   Wed, 27 Mar 2019 18:34:29 +0000
Message-ID: <1553711659-27600-1-git-send-email-peter.oh@bowerswilkins.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0058.namprd07.prod.outlook.com
 (2603:10b6:a03:60::35) To AM0PR04MB6065.eurprd04.prod.outlook.com
 (2603:10a6:208:139::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peter.oh@bowerswilkins.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [12.244.182.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a47842a0-150f-4692-07b3-08d6b2e2d931
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600127)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:AM0PR04MB5793;
x-ms-traffictypediagnostic: AM0PR04MB5793:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <AM0PR04MB57932B6C6A16C5C92AF8DC9899580@AM0PR04MB5793.eurprd04.prod.outlook.com>
x-forefront-prvs: 0989A7979C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(136003)(396003)(346002)(376002)(366004)(199004)(189003)(3846002)(2501003)(15650500001)(10710500007)(5640700003)(316002)(68736007)(50226002)(97736004)(6512007)(8936002)(99286004)(81166006)(54906003)(2420400007)(8676002)(14454004)(478600001)(6306002)(966005)(81156014)(2351001)(7110500001)(86362001)(2906002)(106356001)(6116002)(105586002)(476003)(486006)(256004)(186003)(2616005)(66066001)(386003)(44832011)(25786009)(26005)(53936002)(7736002)(71190400001)(4326008)(6486002)(14444005)(52116002)(71200400001)(305945005)(6506007)(6436002)(6916009)(36756003)(102836004)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB5793;H:AM0PR04MB6065.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: bowerswilkins.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kfsVBh3aZ81iESrUbQy3SWGroPLRc0FYY/EvhSF1HYdrxvMYzyhKLqdGuLc1hXsrMGeYJPsn1a9lUR5oAlhawByupcTisikceNjW97oREb+wR29C7blrkApqoHgtJmYB1ovoapwu8GNr5U7QDOZD20HuLKl5UBs831idrfqAjw/LrD6gEdvjdjGwaoHH14yKHZlbWyCeZ25GKKsFkOA/GMgzDpR0RHhr2Z7+QG7gt4LVCv2o411r91EpS2MbHPnH+R68CzrT51dlCvAQL2RCZvhx89BBj432KkKKorF7LD0V4tdsXW4dgeG/KxDVpeowWTsX1UQT0Q3UPUzlVbz0XiM1CEgMwirkwm7igghk+OHB0t1d2tyxEo3FN/MgvLUdZWb8W9UlcQqFwd7MSceKfmji2202Y2vjpD2GiB8Rs6o=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bowerswilkins.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a47842a0-150f-4692-07b3-08d6b2e2d931
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2019 18:34:29.9388
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a75a45bb-4772-448f-a2c6-9d2413d86410
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5793
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Peter Oh <peter.oh@bowerswilkins.com>

Update power limit as documented in:
https://www.rra.go.kr/FileDownSvl?file_type=3DLAWKR&file_parentseq=3D54&fil=
e_seq=3D27
which revised on November 30, 2016.

Signed-off-by: Peter Oh <peter.oh@bowerswilkins.com>
---
 db.txt | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/db.txt b/db.txt
index 4fb1948..52c17e9 100644
--- a/db.txt
+++ b/db.txt
@@ -695,11 +695,12 @@ country KP: DFS-JP
 	(5735 - 5815 @ 20), (30)
=20
 country KR: DFS-JP
-	(2402 - 2482 @ 40), (13)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (30), DFS
-	(5735 - 5835 @ 80), (30)
+	# ref: https://www.rra.go.kr/ko/reference/lawList_view.do?lw_seq=3D54&lw_=
type=3D3&searchCon=3D&lw_select=3DALL&lw_model=3D&searchTxt=3D
+	(2402 - 2482 @ 40), (23)
+	(5170 - 5250 @ 80), (17), AUTO-BW
+	(5250 - 5330 @ 80), (23), DFS, AUTO-BW
+	(5490 - 5710 @ 160), (23), DFS
+	(5735 - 5835 @ 80), (23)
 	# 60 GHz band channels 1-4,
 	# ref: http://www.law.go.kr/%ED%96%89%EC%A0%95%EA%B7%9C%EC%B9%99/%EB%AC%B=
4%EC%84%A0%EC%84%A4%EB%B9%84%EA%B7%9C%EC%B9%99
 	(57000 - 66000 @ 2160), (43)
--=20
2.7.4

