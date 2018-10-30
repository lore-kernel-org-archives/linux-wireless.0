Return-Path: <SRS0=qkCK=NK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 593E3C2BC61
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 05:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECAE82082B
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 05:53:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="kHL270hS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECAE82082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbeJ3Ops (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 10:45:48 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:53089 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbeJ3Ops (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 10:45:48 -0400
X-IronPort-AV: E=Sophos;i="5.54,443,1534834800"; 
   d="scan'208";a="20344051"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 29 Oct 2018 22:53:44 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 29 Oct 2018 22:53:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BzilcngYqzDfOXioyNawSl1atoMI0BFTsahCm404xtk=;
 b=kHL270hSZhy3KR/1DhsTf+ChbSvu77F9S7sv5P6iRMYQ5JnTH+CBAX5+/xCxoQvTMA16t8yq/KMEyuk8qvWwNE/quB9BFkl8H8DlFmdaIQqJDdJaQRaSvG+XKORLeyHK9fdLOSpiHsRoV1q0m4ripf965tKaWePJ75sD+rAVa5A=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3367.namprd11.prod.outlook.com (20.177.186.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.26; Tue, 30 Oct 2018 05:53:40 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1273.027; Tue, 30 Oct 2018
 05:53:40 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH] staging: wilc1000: update wilc1000 driver maintainer ids
Thread-Topic: [PATCH] staging: wilc1000: update wilc1000 driver maintainer ids
Thread-Index: AQHUcBTo0t5lHo2vaUeorSzybHvUTQ==
Date:   Tue, 30 Oct 2018 05:53:40 +0000
Message-ID: <1540878731-7326-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0071.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::33) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [27.59.88.156]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3367;6:ZyniBKf+jJrNOjJ9QqSAUzxlKPg7/FhYx9Sz3Znqyooq053NF0hBGKJ7q/G2cdwyQsoDHANyxhsT7auaEqY2bL+r6ccC+2BR/4HRmFkVT9jnOJQsbqFm5UjY1605pee5TYL0pSU5SUu+6jwLj/kRUbs7SIq40puMyjGhj86Kqn1Ds68H+mSzFrulkQJ3CqoFOzJDIdo0zcgiyXR0rUjcfd3wJ8FJoq7vv0xKvywZ7nkq6qhvvB70yX5Ktea8ZILYE6nYS3YdoF/i/clIlDSaG3V1L+YG9syN+YS4+1OTa0mbXXu4bXFBhQ3BQsGHNUdR3fsP/eTarOrwOUQSrnyTDAwCRsCM350UYYS6+YMdd7y+9fjr4Wknl/avZSo0Dw9towriV+1IGj58iuD2F9lqcJAOnV04XgGfCRzI7DtIxhctRb6k3uqlZJTvVNSbaXxg+26qRh+vmNN9a6U4/nWPeQ==;5:JR2eMAt/cdsJQ+kpyd7vEJ0e1Tr3XdsnBRNBxwK3esCqFmZgibVK6hoHhMi3niR0QqcHoQ9R02z+BKAiU9sqHrS3eR5RmBoq3+rppEn97L1mk5LXsoPjAWGqg7Kbl3OxtQT4NiKGwTmTpCzqPqNQ6DF5+CkUSdmOvaDdiDOC1tQ=;7:CUfa42hqq2+bVqczLOxRDphYaA2haUNF4DFy5mQbe2eX61tQQgo2dBel6fLiY40AVHnAn1MxFCkOVqXN38K/vd6hziQ/sr4x+v3aikDWslb/1q8kcP94PanA+lU8VXj+KDvIxhi/BlTRQ/ZgKIarOA==
x-ms-office365-filtering-correlation-id: 3cc37484-d3f8-488b-0463-08d63e2c0acb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3367;
x-ms-traffictypediagnostic: BYAPR11MB3367:
x-microsoft-antispam-prvs: <BYAPR11MB336721ED29EA8A314D8F56FDE3CC0@BYAPR11MB3367.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(9452136761055);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3002001)(93006095)(93001095)(10201501046)(3231382)(944501410)(52105095)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB3367;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB3367;
x-forefront-prvs: 08417837C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(366004)(346002)(376002)(136003)(199004)(189003)(6486002)(7736002)(1857600001)(71200400001)(71190400001)(5640700003)(305945005)(4326008)(106356001)(105586002)(25786009)(6512007)(14444005)(72206003)(256004)(2616005)(476003)(15650500001)(478600001)(6436002)(486006)(53936002)(186003)(26005)(107886003)(8676002)(66066001)(6116002)(36756003)(14454004)(97736004)(6506007)(2900100001)(86362001)(99286004)(54906003)(316002)(3846002)(2906002)(102836004)(2351001)(68736007)(5660300001)(5250100002)(6916009)(2501003)(52116002)(8936002)(81156014)(386003)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3367;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: xQpb7AtmOlpmN+D82s3e89ulzWkEPGLfnojuvoj6/Qe0fY5txaA8Ag3U8eAIwUDj4hV7gT/+bHFl/VjQyzexgqAuQ695XeA5kbR2k/Z124NZkU4M+kzWLWvKfh9jNgG6xdHQMFnojyv92zAMWa4XZsMt8u2tgSGWke95uEUdi82q0PS2vMwilHZhkOsCr3GZUekfrvrwrUo1eldtTkNR8r+jn7DNLfO+3sA+4dfZjckMbV6hqgPJI184WXmMujIAn9uSazSmIRLEDQC2FaJ/n+TQ0/ZifvMWMn8SMOQ9d1CB8nYhkeYPgGO+Mvw7VjC3TDmNMbjjVqrvg5die/jtOnAsZsXWhgk7+cyPDRe0WzI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cc37484-d3f8-488b-0463-08d63e2c0acb
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2018 05:53:40.4477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3367
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

We would like to update the maintainer email id's for wilc1000 driver.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Signed-off-by: Adham Abozaeid <adham.abozaeid@microchip.com>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7c7af53..9647ec7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13837,8 +13837,8 @@ S:	Odd Fixes
 F:	drivers/staging/vt665?/
=20
 STAGING - WILC1000 WIFI DRIVER
-M:	Aditya Shankar <aditya.shankar@microchip.com>
-M:	Ganesh Krishna <ganesh.krishna@microchip.com>
+M:	Adham Abozaeid <adham.abozaeid@microchip.com>
+M:	Ajay Singh <ajay.kathat@microchip.com>
 L:	linux-wireless@vger.kernel.org
 S:	Supported
 F:	drivers/staging/wilc1000/
--=20
2.7.4

