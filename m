Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1989C43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 21:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90E4B2084F
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 21:31:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=bowerswilkins.com header.i=@bowerswilkins.com header.b="eM5oyE8q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfDZVbe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 17:31:34 -0400
Received: from mail-eopbgr30064.outbound.protection.outlook.com ([40.107.3.64]:57158
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726246AbfDZVbe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 17:31:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bowerswilkins.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2oJnkRPKjUG+VUmguQak6ThQKhHwVgGN1a6aca1x3R8=;
 b=eM5oyE8qfwVDV4cSns762Cz5/51NZffOhHkYzYgSiVsLVWTvzV/BvFfbXNhWmNH0O5h9bVMELsQt5tHaVYkdryTvhzS46I7+VYG9jMfV6OaTvwF4msnYwnmmuZ27UUdNtZ/qYqRt7uvZs5ZziNZFDhGdszsqOG3GZZw/rE4TCP8=
Received: from AM0PR04MB6065.eurprd04.prod.outlook.com (20.179.32.150) by
 AM0PR04MB6017.eurprd04.prod.outlook.com (20.179.32.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.13; Fri, 26 Apr 2019 21:31:31 +0000
Received: from AM0PR04MB6065.eurprd04.prod.outlook.com
 ([fe80::485d:efe5:102e:2989]) by AM0PR04MB6065.eurprd04.prod.outlook.com
 ([fe80::485d:efe5:102e:2989%3]) with mapi id 15.20.1835.010; Fri, 26 Apr 2019
 21:31:31 +0000
From:   Peter Oh <peter.oh@bowerswilkins.com>
To:     "wireless-regdb@lists.infradead.org" 
        <wireless-regdb@lists.infradead.org>
CC:     Peter Oh <peter.oh@bowerswilkins.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] wireless-regdb: Update regulatory rules for South Korea
Thread-Topic: [PATCH v2] wireless-regdb: Update regulatory rules for South
 Korea
Thread-Index: AQHU/HdqZsgsxQxLTEqJEz6hK6qIkA==
Date:   Fri, 26 Apr 2019 21:31:31 +0000
Message-ID: <1556314283-17842-1-git-send-email-peter.oh@bowerswilkins.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR02CA0047.namprd02.prod.outlook.com
 (2603:10b6:a03:54::24) To AM0PR04MB6065.eurprd04.prod.outlook.com
 (2603:10a6:208:139::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peter.oh@bowerswilkins.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [12.244.182.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 739e2ccc-640d-49d4-e6dd-08d6ca8e8c9e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:AM0PR04MB6017;
x-ms-traffictypediagnostic: AM0PR04MB6017:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <AM0PR04MB6017D01A477967478CEFB91D993E0@AM0PR04MB6017.eurprd04.prod.outlook.com>
x-forefront-prvs: 001968DD50
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(136003)(396003)(39850400004)(346002)(376002)(366004)(189003)(199004)(3846002)(6116002)(66556008)(73956011)(66946007)(8676002)(66476007)(66066001)(5640700003)(6916009)(64756008)(7110500001)(86362001)(305945005)(102836004)(7736002)(50226002)(71190400001)(71200400001)(54906003)(4326008)(8936002)(68736007)(2906002)(81166006)(26005)(81156014)(66446008)(316002)(52116002)(53936002)(44832011)(256004)(99286004)(14444005)(5660300002)(478600001)(6512007)(25786009)(476003)(6506007)(486006)(386003)(2616005)(36756003)(2420400007)(6306002)(6436002)(15650500001)(186003)(2351001)(97736004)(14454004)(966005)(2501003)(6486002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB6017;H:AM0PR04MB6065.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: bowerswilkins.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: O0OxQhESsxBUjvcmXeDDhOA6HwcoE0Y/PkqWEuJ4n7LHo5bNXirnYAXKt4010O8tHTsZFRpgDqg8fzh3kCyVkc3TvyWIuiwTTMWWCCH1/hFFi77Dx13CLntiXoSuRUmCQsTq0IIzhPE2pUs7zfpreVM8Jfi/nEBP3KcEhcZcr5nufkn9Ylc3VXQf15M6lNHDkd2DR19StSGTYRKTSs7F46qO7wIDZgkUxqiO5Zc8eulb9NJlgHb5Nz9w6eClrYRLdL9BykD5/dVAAGM5w0SB4eKClIxVpXTAVB8UxDXjtFjwcw32s07pGofxcoRFHW1LG/4SaWxyjMz7PQE3epPQnY3V9WkdJabp4hy/aImDP3EoAwfmB06kzbddABvBZdQdLtT5ZhtWUSABgUFy/36H6gwf5HzCzuSL7h60AljUKvQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bowerswilkins.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 739e2ccc-640d-49d4-e6dd-08d6ca8e8c9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2019 21:31:31.6962
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a75a45bb-4772-448f-a2c6-9d2413d86410
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6017
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

RnJvbTogUGV0ZXIgT2ggPHBldGVyLm9oQGJvd2Vyc3dpbGtpbnMuY29tPg0KDQpVcGRhdGUgcG93
ZXIgbGltaXQgYXMgZG9jdW1lbnRlZCBpbjoNCmh0dHA6Ly93d3cubGF3LmdvLmtyLyVFRCU5NiU4
OSVFQyVBMCU5NSVFQSVCNyU5QyVFQyVCOSU5OS8NCiVFQyU4QiVBMCVFQSVCMyVBMCVFRCU5NSU5
OCVFQyVBNyU4MCVFQyU5NSU4NCVFQiU4QiU4OCVFRA0KJTk1JTk4JUVBJUIzJUEwJUVBJUIwJTlD
JUVDJTg0JUE0JUVEJTk1JUEwJUVDJTg4JTk4JUVDJTlFDQolODglRUIlOEElOTQlRUIlQUMlQjQl
RUMlODQlQTAlRUElQjUlQUQlRUMlOUElQTklRUIlQUMlQjQNCiVFQyU4NCVBMCVFQSVCOCVCMCVF
QSVCOCVCMC8oMjAxOC04OSwyMDE4MTIyNykNCndoaWNoIHJldmlzZWQgb24gRGVjZW1iZXIgMjcs
IDIwMTguDQoNClNpZ25lZC1vZmYtYnk6IFBldGVyIE9oIDxwZXRlci5vaEBib3dlcnN3aWxraW5z
LmNvbT4NCi0tLQ0KIGRiLnR4dCB8IDExICsrKysrKy0tLS0tDQogMSBmaWxlIGNoYW5nZWQsIDYg
aW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RiLnR4dCBiL2Ri
LnR4dA0KaW5kZXggNGZiMTk0OC4uOGQyNDMwNSAxMDA2NDQNCi0tLSBhL2RiLnR4dA0KKysrIGIv
ZGIudHh0DQpAQCAtNjk1LDExICs2OTUsMTIgQEAgY291bnRyeSBLUDogREZTLUpQDQogCSg1NzM1
IC0gNTgxNSBAIDIwKSwgKDMwKQ0KIA0KIGNvdW50cnkgS1I6IERGUy1KUA0KLQkoMjQwMiAtIDI0
ODIgQCA0MCksICgxMykNCi0JKDUxNzAgLSA1MjUwIEAgODApLCAoMjApLCBBVVRPLUJXDQotCSg1
MjUwIC0gNTMzMCBAIDgwKSwgKDIwKSwgREZTLCBBVVRPLUJXDQotCSg1NDkwIC0gNTcxMCBAIDE2
MCksICgzMCksIERGUw0KLQkoNTczNSAtIDU4MzUgQCA4MCksICgzMCkNCisJIyByZWY6IGh0dHBz
Oi8vd3d3LnJyYS5nby5rcg0KKwkoMjQwMiAtIDI0ODIgQCA0MCksICgyMykNCisJKDUxNzAgLSA1
MjUwIEAgODApLCAoMjMpLCBBVVRPLUJXDQorCSg1MjUwIC0gNTMzMCBAIDgwKSwgKDIzKSwgREZT
LCBBVVRPLUJXDQorCSg1NDkwIC0gNTcxMCBAIDE2MCksICgyMyksIERGUw0KKwkoNTczNSAtIDU4
MzUgQCA4MCksICgyMykNCiAJIyA2MCBHSHogYmFuZCBjaGFubmVscyAxLTQsDQogCSMgcmVmOiBo
dHRwOi8vd3d3Lmxhdy5nby5rci8lRUQlOTYlODklRUMlQTAlOTUlRUElQjclOUMlRUMlQjklOTkv
JUVCJUFDJUI0JUVDJTg0JUEwJUVDJTg0JUE0JUVCJUI5JTg0JUVBJUI3JTlDJUVDJUI5JTk5DQog
CSg1NzAwMCAtIDY2MDAwIEAgMjE2MCksICg0MykNCi0tIA0KMi43LjQNCg0K
