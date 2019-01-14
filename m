Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0EC4C43387
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA39620659
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:41:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="TGeNlA+7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbfANJlC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Jan 2019 04:41:02 -0500
Received: from mail-eopbgr710076.outbound.protection.outlook.com ([40.107.71.76]:23296
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726534AbfANJlC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Jan 2019 04:41:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQQ7qDSZU79SgWvL7ySSsgjcHu98628R4hDFE5kyiMQ=;
 b=TGeNlA+7LbiO0jJrP6s37Hlrpx4yqHp2VQ5RyRFJZxU5Ym2nh01N6QI9aKpdo7voFjJ8njS3N8OyhPU18f38gaJOXBAhHErCNUlYefBvZGpvbLu9E7NJoOx+WdB6MYs5H2S4xb+D5UBWOHifeFjnZF0cBdWvq7gOF49HDQTUQi0=
Received: from CY4PR0501MB3873.namprd05.prod.outlook.com (52.132.100.150) by
 CY4PR0501MB3827.namprd05.prod.outlook.com (52.132.100.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.18; Mon, 14 Jan 2019 09:40:52 +0000
Received: from CY4PR0501MB3873.namprd05.prod.outlook.com
 ([fe80::f9eb:3f89:1cf3:30f8]) by CY4PR0501MB3873.namprd05.prod.outlook.com
 ([fe80::f9eb:3f89:1cf3:30f8%4]) with mapi id 15.20.1537.018; Mon, 14 Jan 2019
 09:40:52 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4719.namprd05.prod.outlook.com (52.135.114.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.17; Mon, 14 Jan 2019 09:39:49 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5%6]) with mapi id 15.20.1537.018; Mon, 14 Jan 2019
 09:39:49 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 8/9] qtnfmac: remove unused declarations
Thread-Topic: [PATCH v2 8/9] qtnfmac: remove unused declarations
Thread-Index: AQHUq+0XcvOinKzFYUajo/r7qJSRew==
Date:   Mon, 14 Jan 2019 09:39:49 +0000
Message-ID: <20190114093925.9061-9-sergey.matyukevich.os@quantenna.com>
References: <20190114093925.9061-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20190114093925.9061-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0070.namprd05.prod.outlook.com
 (2603:10b6:a03:74::47) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;CY4PR0501MB3827;6:uRV6mRKcHXVwuN2bvpUmDGepVlxFGxSc2mLrriGj8znocqnFJaZOJvW/CUxa+BFJS3B8AdJPZfgYQw2kX+koAQmA7DYLbuwRUZ/UZIQDxJe+MQplCrstdjc0Y/07fs5y+UV6HjjcoF+evu/3OsMAxBUbO8OkKbp8I/MT7zMNXGc9UBk9TyYKkn7qPZNpuVyFoS7M0iVXLMX5TL5KdiT+FhMkATrxCMx5npNAYUI867nbbuBJBX+oANsUNlS1xgm1329KK7i7375v62zb3hVKm9397eAMXS9WpFbOxrhR4LwOjJj7Ww76Hea85TkfmxzwgKb8QcGn77gX2K5SQJrknshafod/yYOqDmXFsHBNO4UVnhr1TBfjgKJkJQW7wsd6uNvGYmsC2bmkMd9eOeiXMaiEC7SUzpoWEWsSaOF8SHdj7xCfahtmRPyCHv37nBEO911Krgb2OK/aUh0kJQ/eUw==;5:jxHDX5cT2vPsJVX2cJ++ory2xwuEEaPNOfdU6gXLhuyVhdMSJKpLOfJayF3/+kAAhTF9YoBSWAoKlr6+pN6fHzyDNMlBCP5+vmvHqGuUIb0zp8Jx5745lRD12WtpMCIh4hvSvKRXDSQ2diXETnhSefTe4RHR8lj5wPQFABdWE6hJfQETeZGZS+DkJFPH54D7fqAkZc1NjwMYZkL1AnVIrw==;7:JpoiaN5CvlfOHGoadL21nnntGI9xDRltT3W4wbsMto7P+CPLE9lLFliTX5QOtBlxlKBPM4KxvTSiP7TXB3a9XUFb6pktAv49qegv4fUC2lrloLBxcDuiv6gSe3m2ojb3Ne2+8p1Fg+3t+JXaglSlXA==
x-ms-office365-filtering-correlation-id: 6eebdff8-c3cb-4268-bb90-08d67a0439dc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600109)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB4719;
x-ms-traffictypediagnostic: SN6PR05MB4719:|CY4PR0501MB3827:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-moderation-data: 1/14/2019 9:40:50 AM
x-microsoft-antispam-prvs: <CY4PR0501MB3827EA68E9048B3DAB7DF1A6A3800@CY4PR0501MB3827.namprd05.prod.outlook.com>
x-forefront-prvs: 0917DFAC67
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(346002)(376002)(366004)(39840400004)(189003)(199004)(2616005)(103116003)(86362001)(478600001)(476003)(5640700003)(6916009)(316002)(54906003)(6486002)(6436002)(436003)(97736004)(2501003)(14454004)(25786009)(3846002)(6116002)(386003)(66066001)(6506007)(486006)(7736002)(102836004)(52116002)(446003)(76176011)(11346002)(4326008)(26005)(305945005)(36756003)(186003)(8676002)(81156014)(81166006)(8936002)(5024004)(68736007)(2351001)(107886003)(6512007)(53936002)(1076003)(5660300001)(2906002)(99286004)(71200400001)(71190400001)(106356001)(256004)(105586002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR0501MB3827;H:CY4PR0501MB3873.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QsqQc8z0QyFKu3EkIdDRuQ8WELVl4DODssjTrMocYWNaFKpOl97sijZdm5v4l7bjVM7etsYi6HtNvjyjAamJlPGiaeqhRIpvoW1m+RC/M/n1i+kZvLnUWw1FFrWK4Gb9QcjMJCjL1kII7CFd2F9ei8GW4yhomFNlUQQR2WzJVC3pojOW+IEpgHqOy6VP2BRPqTl4TSMwqnT6wFH6xDSFtXmYS3EvJQyrTtCMBdzS6GVgmGJ6yGIn5oWflZUeWgC8nZV0JKHaZGbsirSRG846bSh83b+xLo8/3VvnNexkViZn2sxDdpotpmtZw3gYc8hPUpLB86BWMxldaKSJaU4mvol5awpu7MlBY36FsSFrzjhHrJI16Lc2wEkhOFHzguu+wREUqlJ5tXfCgs34qWYBAxTxSn2SmHVp0knAaqSBzdo=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eebdff8-c3cb-4268-bb90-08d67a0439dc
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2019 09:40:52.5182
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0501MB3827
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove declarations for inexistent functions from bus.h header.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/bus.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/bus.h b/drivers/net/wir=
eless/quantenna/qtnfmac/bus.h
index 7bd906cc7023..14b569b6d1b5 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/bus.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/bus.h
@@ -122,7 +122,5 @@ static __always_inline void qtnf_bus_unlock(struct qtnf=
_bus *bus)
=20
 int qtnf_core_attach(struct qtnf_bus *bus);
 void qtnf_core_detach(struct qtnf_bus *bus);
-void qtnf_txflowblock(struct device *dev, bool state);
-void qtnf_txcomplete(struct device *dev, struct sk_buff *txp, bool success=
);
=20
 #endif /* QTNFMAC_BUS_H */
--=20
2.11.0

