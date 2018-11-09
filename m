Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9373C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 07:12:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9381E204FD
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 07:12:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="N5Pru5wJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9381E204FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbeKIQv7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 11:51:59 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:50998 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbeKIQv7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 11:51:59 -0500
X-IronPort-AV: E=Sophos;i="5.54,482,1534834800"; 
   d="scan'208";a="23854679"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 09 Nov 2018 00:12:41 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Fri, 9 Nov 2018 00:12:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D7NZm82tKng28SlJ1CYYZ/f41eed+UGMJybrO3KgXeg=;
 b=N5Pru5wJaQiTyxLK2BgINipcNetZcY9ZIPah9QUDzxMg0b7Igcedxl4NvgS1e0eDOTgTrGnlNbNPy4cyKX863Gg+wdopascAyEkQfkW79SUDXwUsaV5iaoTszJiZy3rl2/NCvp3OBs+2UFfRcNG5stK9t54qfWSAFW1NimbSEgs=
Received: from BL0PR11MB2994.namprd11.prod.outlook.com (20.177.204.16) by
 BL0PR11MB3074.namprd11.prod.outlook.com (20.177.205.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.21; Fri, 9 Nov 2018 07:12:30 +0000
Received: from BL0PR11MB2994.namprd11.prod.outlook.com
 ([fe80::1d60:bdd5:aea6:6630]) by BL0PR11MB2994.namprd11.prod.outlook.com
 ([fe80::1d60:bdd5:aea6:6630%5]) with mapi id 15.20.1294.034; Fri, 9 Nov 2018
 07:12:29 +0000
From:   <Ganesh.Krishna@microchip.com>
To:     <Ajay.Kathat@microchip.com>, <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Aditya.Shankar@microchip.com>, <Adham.Abozaeid@microchip.com>,
        <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] staging: wilc1000: update wilc1000 driver maintainer
 ids
Thread-Topic: [PATCH v2] staging: wilc1000: update wilc1000 driver maintainer
 ids
Thread-Index: AQHUdldweLlZyim0q0+Fr2iLe6GHuaVGlRYA
Date:   Fri, 9 Nov 2018 07:12:29 +0000
Message-ID: <4A9C4B2D-79F2-4CC2-BE85-BA1D4BCC8F25@microchip.com>
References: <1541567062-5793-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1541567062-5793-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.11.0.180909
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ganesh.Krishna@microchip.com; 
x-originating-ip: [2600:8800:1e09:7e01:fc73:138b:10dd:8530]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR11MB3074;6:2xkK5iNhwTZkj7578fpjSm0V6swbmXnJJPrQvJ+Y0Yx3ea6Yw261ksGseI2OBKm/2aXidhn4nTi+/TSjWFgXJr35qzi0CwjLSBF/650DHuQPT1c1+/xG3pONYVo0Pg/U0Uc5okyqdfL9UX/DDEPMEtC80jwWIL3KZpK969wonJVqLyPEel13EqINjyBiMB/2r+ARaNH7bf07kO2WP0c5wTtsz3nCNDF9zG0YVw+EMCrnNv6xE7GPGucT9q6IvGYSxVBZJ+JMAW0Vp/7bHIhyJEauEQzMNcyojhZ0+kj3kOVzzPglqiK0+6q3GxJY818L2bZl1ZI1RXIyrC8V5QzrtZj2ygpZAuxE+EAeFNtzkxIs4kKsnLIMkhWEwgO4ZWyebhXAY41OPpmdDcN6Ed7IJl2J6qnh5yJ6MTT30LkfYLtlKEuki9GeIwrUZz3xMEgSwh8BoEBeUZ4tD2FxTLurqQ==;5:0DV/kbHU/ck2U8YoCZwXWmHpBtb7F3aqx9NZdxAU3HAJAoPYx8eFHXQ7/f2JOBs67/Ae98+NwAnlc5kOs5RyjBYskDaAYNI5DHQ0T6vBS4gKs6l3jx0Q14ukEBVsySTtYSS7ovbjZA2ybfffe3B/IizKIlyKG1ewSR9TyyuISO4=;7:u75wqXlsPlNoE104NnacQW8uwRJEaOKY5RfuvHyfYgPfvFfBa3Ybvr0OF1IykziRfkRIx7wwKDjClpF3/VFhF5EvrDM6esMfH9pWCJ53FNSMqw+EIVrOkHaP4rsEPlAD3V8TuLMxzqMHq/P81xXyJQ==
x-ms-exchange-antispam-srfa-diagnostics: SOS;SOR;
x-forefront-antispam-report: SFV:SKI;SCL:-1;SFV:NSPM;SFS:(10009020)(39860400002)(366004)(346002)(396003)(376002)(136003)(189003)(199004)(2501003)(33656002)(76176011)(6506007)(46003)(15650500001)(99286004)(102836004)(186003)(86362001)(81156014)(81166006)(97736004)(68736007)(71200400001)(478600001)(83716004)(71190400001)(476003)(2616005)(7736002)(8676002)(6116002)(446003)(486006)(11346002)(53936002)(305945005)(6512007)(82746002)(25786009)(316002)(14454004)(4326008)(110136005)(229853002)(8936002)(14444005)(256004)(72206003)(58126008)(36756003)(2906002)(5660300001)(6436002)(6486002)(6246003)(106356001)(105586002)(2900100001)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR11MB3074;H:BL0PR11MB2994.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-office365-filtering-correlation-id: d2d088bf-8d66-47d4-37d6-08d64612b5c3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR11MB3074;
x-ms-traffictypediagnostic: BL0PR11MB3074:
x-microsoft-antispam-prvs: <BL0PR11MB30746B01F1A192D029CE251481C60@BL0PR11MB3074.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(9452136761055);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231382)(944501410)(52105095)(3002001)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123564045)(20161123560045)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:BL0PR11MB3074;BCL:0;PCL:0;RULEID:;SRVR:BL0PR11MB3074;
x-forefront-prvs: 08512C5403
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: NnesqLwxBM/larruuF8xxwuyn5DQDj0BJRZWeDLWhgGajVMkMqL3kkO+LHKVBHtJaktNOO2z13/HtmWvfgmwzsGuNysQPRPMrIg0lUr4vhJKlb02otKQ1SNzDCMa2Pregl+R2LaPOADfjAIS5GstwsqDIyXWHbtBVqMrXiYgpSAPDXSDlI98EC36y4dpkaV0luEfQPDXVLP3SGIeW3qgesu0tE6Y0IE4sRhlwfDFUcwdqvJAIVL/H7gLbHMs0T5zyR8/Y6ayEJ2qS29s7LSkMsmup/Fj+SmJ8zrYU7/yHz/JcDIrkBaoasYIzgMhwqnVPJs+J2oBUNMUdh1PUYNq8yRWVMbaiZq7O5oH/fnbxXI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <0102E8499C38434299422921AA5234AB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d2d088bf-8d66-47d4-37d6-08d64612b5c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2018 07:12:29.1258
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3074
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQrvu78gICAgRnJvbTogQWpheSBTaW5naCA8YWpheS5rYXRoYXRAbWljcm9jaGlwLmNvbT4NCiAg
ICANCiAgICBXZSB3b3VsZCBsaWtlIHRvIHVwZGF0ZSB0aGUgbWFpbnRhaW5lciBlbWFpbCBpZCdz
IGZvciB3aWxjMTAwMCBkcml2ZXIuDQogICAgDQogICAgU2lnbmVkLW9mZi1ieTogQWRpdHlhIFNo
YW5rYXIgPGFkaXR5YS5zaGFua2FyQG1pY3JvY2hpcC5jb20+DQogICAgU2lnbmVkLW9mZi1ieTog
R2FuZXNoIEtyaXNobmEgPGdhbmVzaC5rcmlzaG5hQG1pY3JvY2hpcC5jb20+DQogICAgU2lnbmVk
LW9mZi1ieTogQWRoYW0gQWJvemFlaWQgPGFkaGFtLmFib3phZWlkQG1pY3JvY2hpcC5jb20+DQog
ICAgU2lnbmVkLW9mZi1ieTogQWpheSBTaW5naCA8YWpheS5rYXRoYXRAbWljcm9jaGlwLmNvbT4N
Cg0KQWNrZWQtYnk6IEdhbmVzaCBLcmlzaG5hIDxnYW5lc2gua3Jpc2huYUBtaWNyb2NoaXAuY29t
Pg0KDQogICAgLS0tDQogICAgQ2hhbmdlcyBpbiB2MjoNCiAgICAJLSBhZGRlZCBzb2Igb2YgY3Vy
cmVudCB3aWxjMTAwMCBtYWludGFpbmVycw0KICAgIC0tLQ0KICAgICBNQUlOVEFJTkVSUyB8IDQg
KystLQ0KICAgICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygt
KQ0KICAgIA0KICAgIGRpZmYgLS1naXQgYS9NQUlOVEFJTkVSUyBiL01BSU5UQUlORVJTDQogICAg
aW5kZXggZjQ4NTU5Ny4uNDlhZTAzZiAxMDA2NDQNCiAgICAtLS0gYS9NQUlOVEFJTkVSUw0KICAg
ICsrKyBiL01BSU5UQUlORVJTDQogICAgQEAgLTE0MTMyLDggKzE0MTMyLDggQEAgUzoJT2RkIEZp
eGVzDQogICAgIEY6CWRyaXZlcnMvc3RhZ2luZy92dDY2NT8vDQogICAgIA0KICAgICBTVEFHSU5H
IC0gV0lMQzEwMDAgV0lGSSBEUklWRVINCiAgICAtTToJQWRpdHlhIFNoYW5rYXIgPGFkaXR5YS5z
aGFua2FyQG1pY3JvY2hpcC5jb20+DQogICAgLU06CUdhbmVzaCBLcmlzaG5hIDxnYW5lc2gua3Jp
c2huYUBtaWNyb2NoaXAuY29tPg0KICAgICtNOglBZGhhbSBBYm96YWVpZCA8YWRoYW0uYWJvemFl
aWRAbWljcm9jaGlwLmNvbT4NCiAgICArTToJQWpheSBTaW5naCA8YWpheS5rYXRoYXRAbWljcm9j
aGlwLmNvbT4NCiAgICAgTDoJbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnDQogICAgIFM6
CVN1cHBvcnRlZA0KICAgICBGOglkcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvDQogICAgLS0gDQog
ICAgMi43LjQNCiAgICANCiAgICANCg0K
