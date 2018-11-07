Return-Path: <SRS0=0pA5=NS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A165C0044C
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 05:05:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0034C2081D
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 05:05:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="n8YIoYpm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0034C2081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388756AbeKGOdu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Nov 2018 09:33:50 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:40891 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387848AbeKGOdu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Nov 2018 09:33:50 -0500
X-IronPort-AV: E=Sophos;i="5.54,474,1534834800"; 
   d="scan'208";a="23729094"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 06 Nov 2018 22:05:05 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 6 Nov 2018 22:05:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8HFYQd8bauUA9L7I+o4HZV+XiFCSeIfsJ8TN56MKPc0=;
 b=n8YIoYpmoHXtEldU8u8xQC8UwMlLT9P55kv7BjPpz1uRSi4eV++sylFZgovMSUXL/vDKlpYCHhCXwmZBMrVInmb277k2rYAHnR7s2/pD+iW+KHkociAZxOXRj1Rrg2iqErOyjYH290SEND2AvK3TVqm31qrrBkK10I0yRjfpKyo=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3128.namprd11.prod.outlook.com (20.177.227.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.27; Wed, 7 Nov 2018 05:05:01 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1294.034; Wed, 7 Nov 2018
 05:05:01 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH v2] staging: wilc1000: update wilc1000 driver maintainer ids
Thread-Topic: [PATCH v2] staging: wilc1000: update wilc1000 driver maintainer
 ids
Thread-Index: AQHUdldweLlZyim0q0+Fr2iLe6GHuQ==
Date:   Wed, 7 Nov 2018 05:05:01 +0000
Message-ID: <1541567062-5793-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0135.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::29) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [27.59.79.168]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3128;6:qHc1m+GBPrUIsOvgJQe5bnvNcm3KjNhh9m1JcJOP2Ld5atExcdr8oNAq9wYRq1fEBJ/PHx30u+quk5Otdfz1OHGn2ZGa5iqvTKsQYxCCswZ7rlNStkU8Y4v8gKtJ8YX3c2G/72EKPoqn5AU1VbpdRn7UvD0vLzeZEGVAMs6kOkfWp35YgbE0ymkyEyPc9m5ra3kNFdinu2xIsfvFCE7Qb+8Jszn13SAuN03mWRjeqw9RCnVp78apm5uUhzQlpL8m/cIyVr9vKLK2XLx9BXP+qCWlrsiNvgG33dRVynYtM3Fb4NnT+kxVWO1dl3LIT+yxWfeSfYZ0Hmhgt6wXo4m9Q86SMU5Vvs25R5akQllUzUbB4TpKzx0S4tDbkLS9Q5/msROQCuiUW7Ey+RUFN8MZv040fGqI+fxx6A+rRlj5X7MrpmZ9o8auXH9l+HKStOZ6neJVsvxaZ8QByCeWIQB+RA==;5:cVSPaAFgQuN8BPuxYNK81iWcThME7EMfe0s6hS4eFDM0S5k+T33g/FEX/3Abiaap5Uy8uE4vm1SmeKKiuxn03PsvoBgE+yuC1QCgLGJbdj+ihFTJPYQJr4/TnjbbYiku41/yjK3BSOXcyz5gfpSlcq0FwHY1czfGdaDF5P2AYKQ=;7:YTdMzW1Bn24lvPar66Hv0ag3JEWsqlM+Sc5q3KqZjgccDZkY2/HiPUhiTTOGDczri38LIR3G6lWOdYCB0QSRu/vr7zuYlc3Zx0PC5eIXFfS3+q61hJ3NhDmu2fqzLK45yiV0xMjc7uH944YZs0//YQ==
x-ms-office365-filtering-correlation-id: 6912ca5f-1c18-4c29-c4a3-08d6446e9207
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3128;
x-ms-traffictypediagnostic: BYAPR11MB3128:
x-microsoft-antispam-prvs: <BYAPR11MB3128E25C076D466081493FF7E3C40@BYAPR11MB3128.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(9452136761055);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231382)(944501410)(52105095)(3002001)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123560045)(20161123564045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB3128;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB3128;
x-forefront-prvs: 08497C3D99
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(376002)(39860400002)(366004)(396003)(346002)(136003)(189003)(199004)(105586002)(66066001)(2906002)(3846002)(6116002)(6916009)(106356001)(99286004)(386003)(6506007)(68736007)(71190400001)(4326008)(6436002)(6486002)(5660300001)(81166006)(2501003)(478600001)(2900100001)(36756003)(72206003)(15650500001)(25786009)(102836004)(14444005)(97736004)(256004)(186003)(5640700003)(316002)(6512007)(81156014)(305945005)(71200400001)(54906003)(14454004)(8676002)(53936002)(26005)(107886003)(86362001)(2616005)(476003)(52116002)(2351001)(7736002)(8936002)(486006)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3128;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 78ceudiu/QoN+Qbo+UNbSc0X4nx8h8WOaYTa3InNcKmFXqjIELpVdQet0c2wpEchwx+mBpqHQ+Zx/Q97Snw3uSZ/PJKdUwv6REfk4ch7NrMSDkyvX8ARkle8z5YXXJqWreqf1F5DJEu8P5hI9L4aHD/Iib7N4GazIfFNlErNkdFCmXZ06wrA6CQ3GiwMKt9cTxXdppCwMXNW/+/qwlhBOXuWOVoZKkoLtceestL7lCbJGKU56htMUdTm7ZPb/0fsNVN20QyjrS1sJwUpMXdfAtr8hredz58qVkfIW+Db0XfZ8yvFjwXs7u08cA7QRghvCYCaYFzA7NTB2in/blq3KPZmA5Dcnscypo0P8XQpMNg=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6912ca5f-1c18-4c29-c4a3-08d6446e9207
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2018 05:05:01.5354
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3128
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

We would like to update the maintainer email id's for wilc1000 driver.

Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
Signed-off-by: Ganesh Krishna <ganesh.krishna@microchip.com>
Signed-off-by: Adham Abozaeid <adham.abozaeid@microchip.com>
Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
Changes in v2:
	- added sob of current wilc1000 maintainers
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f485597..49ae03f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14132,8 +14132,8 @@ S:	Odd Fixes
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

