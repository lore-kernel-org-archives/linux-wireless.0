Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91814C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 08:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61067214DA
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 08:16:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="UApJ1RhT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbfAJIQM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 03:16:12 -0500
Received: from mail-eopbgr690085.outbound.protection.outlook.com ([40.107.69.85]:35860
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727488AbfAJIQM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 03:16:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zKp7fC92Ewm7KY+syxtLnU3YpyrcGbqqqSmIj5anUqQ=;
 b=UApJ1RhT9om/rvRNffNnonIbjM3nlAL2H4GB2/kDnG41a0OHRO6aIUCDGP/GVw8E4LHHdu9t4WMeHzH7J8dalGgwZT58zCKeFJF5CPvtFBU63uNXzmjLbOM4Sjfi1W2wGjUapvgKI/TerFly3QQOjqlhrBTdF/qdooQT/gs7HM4=
Received: from DM6PR05MB4714.namprd05.prod.outlook.com (20.176.109.215) by
 DM6PR05MB5644.namprd05.prod.outlook.com (20.176.123.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.6; Thu, 10 Jan 2019 08:16:01 +0000
Received: from DM6PR05MB4714.namprd05.prod.outlook.com
 ([fe80::d479:121:55ed:92c7]) by DM6PR05MB4714.namprd05.prod.outlook.com
 ([fe80::d479:121:55ed:92c7%3]) with mapi id 15.20.1516.015; Thu, 10 Jan 2019
 08:16:01 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4303.namprd05.prod.outlook.com (52.135.73.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.3; Thu, 10 Jan 2019 08:15:46 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5%6]) with mapi id 15.20.1516.015; Thu, 10 Jan 2019
 08:15:46 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: Re: [PATCH 6/7] qtnfmac: convert to SPDX license identifiers
Thread-Topic: [PATCH 6/7] qtnfmac: convert to SPDX license identifiers
Thread-Index: AQHUqDWkiZBF5evYTEWKrejtV7PYJ6WoHlM8gAAKm4A=
Date:   Thu, 10 Jan 2019 08:15:45 +0000
Message-ID: <20190110081540.6zfr47nxbknofzta@bars>
References: <20190109160843.14832-1-sergey.matyukevich.os@quantenna.com>
 <20190109160843.14832-7-sergey.matyukevich.os@quantenna.com>
 <875zux6jzy.fsf@purkki.adurom.net>
In-Reply-To: <875zux6jzy.fsf@purkki.adurom.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR02CA0018.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::31) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM6PR05MB5644;6:0utJbqoElXtEiPnBj8XmIF1PagSoGYgQAewxloGXHa0+2Xq1wkIzwdmYklUhxCrihWdN7I+VU0VMzq9NXwBiJ4mWh+uJsxM4W3PPqnfvxN5q3l2CnzP8oNy56cDl+wMQKz7dHF2T7jTHvyY7edzSKNLmGksFTfwTVf2/p3ln1DxlJf8ogYbGS62JcdLDmrvkEtp9kz/og1elFf+cmfcpSdzLWnzyvWYdQezWXF2bVV6tz/pipqpWMtfMS0yiNBXrj5CulIrH14Vgc+KV12Cx1xeGX19A/MT1yC4s2nN53eT3kZx4AtduB545cYlZs/dfgXlrNsiVbqt2oYrLB0snxJb4Ywa/h9xpZp/a7q+ifv1jOizhP1l5tnDpvBUXrQ3+ePjA6w/WRLrXzww6oze9aJk5Nhog/ZlVerdaX5mbhy9zZApXiCXDgA+BBVIbc/fgheQLVXosXdJqb3ouImjldg==;5:crgbJrkVbgbo/6IjzAI/4qRRXlnxD/z54g5md4JdJM5C3RxrmmI3u/VD89J3QRE6Kj5jcYNlcBZtleSUWY15akrJHxRqdFgBgklmqgtr/59JD7KJuqZNqrJH9W5/R47nYFmV1BORvPZurkv0nQelyIBjCiyMSEq+HPZkjCTqFKHPLB0L/Lai84DO0qlPN71eeoMsBZYHXE8ibyHPeIOyfQ==;7:SYaYktGb+sL0p1toU68mWC0rh91ZknKIxP7GuAMzUoXMlLuqUWcy/Lz74K7HVZ5JA6iEGxMl5g2S84Cxt+nLNaAWEwi0lkiWRfyHuQvGDpDqREDkfi+QEaNcVYW+vWzdpW95QD80HhGwR7QoT+443A==
x-ms-office365-filtering-correlation-id: e9fed3cf-513f-434f-c2fd-08d676d3d22b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB4303;
x-ms-traffictypediagnostic: SN6PR05MB4303:|DM6PR05MB5644:
x-moderation-data: 1/10/2019 8:15:58 AM
x-microsoft-antispam-prvs: <DM6PR05MB5644272DDFACA38930B62BF4A3840@DM6PR05MB5644.namprd05.prod.outlook.com>
x-forefront-prvs: 0913EA1D60
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(39850400004)(136003)(376002)(346002)(366004)(396003)(199004)(189003)(6512007)(9686003)(6246003)(1076003)(107886003)(71190400001)(81166006)(81156014)(105586002)(71200400001)(2906002)(106356001)(66066001)(6436002)(8676002)(3846002)(6116002)(6486002)(99286004)(256004)(97736004)(446003)(33716001)(436003)(86362001)(11346002)(7736002)(54906003)(316002)(5660300001)(68736007)(478600001)(6346003)(102836004)(305945005)(26005)(14454004)(53936002)(6916009)(25786009)(4326008)(486006)(386003)(8936002)(6506007)(229853002)(186003)(33896004)(476003)(52116002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR05MB5644;H:DM6PR05MB4714.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FhufSlW2wjV6swMdNljnyfgiQNQzhSgDBpK6DS2o0t1ysyFg7neUDw+xA1734z3ieiaXCLrIp3KXMmCwYjG/ZB9DN+nFOAFtdhxZ+6jI20IcawW6Y7yp2jz8o8XM04aMFHgOzNf9fwmujWwkz8cgOoB3wHPy4TvsLO9WzbAeKt+kzf/OseCzY0PQHugdlqw86Ihhlgjs8s2MsaidBgwiF69F+XnGatc0Gpn9EluEuRdu3N3CYsMXDjqJq/nFve3Kc9Tfogetz+zbouz7c05A+/2AU5XlB/g2zg/pjKfZj0832+hCnJ7cFG4StBZMQZjxlvqkOIwItqYX8wom1LbuvZSIEpZIcRYmnXDv7WPKJK3XFOauqscZ0sXPoQ1RRNDkBPCMgzXmABKtMRVVz7u3Q1rDe+7S13veUDpazjI5aA86177bI8SGtieXpmclQVI7OqfM6Zi+YB1ZehjTxExKhg==
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2A8652403FA7FB498D801A4E3E100B5C@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9fed3cf-513f-434f-c2fd-08d676d3d22b
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2019 08:16:01.0385
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB5644
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Kalle,

> Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:
>=20
> > Replace textual license with SPDX-License-Identifier.
> > Add an SPDX-License-Identifier for the Makefile.
> >
> > Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
>=20
> [...]
>=20
> > --- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h
> > +++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h
> > @@ -1,3 +1,6 @@
> > +/* SPDX-License-Identifier: GPL-2.0+ */
> > +/* Copyright (c) 2015-2016 Quantenna Communications. All rights reserv=
ed. */
> > +
> >  /*
> >   * Copyright (c) 2015-2016 Quantenna Communications, Inc.
> >   * All rights reserved.
>=20
> This doesn't look correct, please check.

Oh, I missed that one. Thanks for catching. All the other SPDX changes
looks ok. This issue is fixed and will be queued into v2 of this patch set.


Regards,
Sergey
