Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC30C00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF61D2086D
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:56:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="xNkYdp6g"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF61D2086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbeJHRG5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 13:06:57 -0400
Received: from mail-sn1nam02on0089.outbound.protection.outlook.com ([104.47.36.89]:36736
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726330AbeJHRG5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 13:06:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ks7buC8BoDzOdxqnkxExZ8qygw6jrcK/aNebvuV9jY=;
 b=xNkYdp6gpGMPv3fJTChknkqjSAkT8v6X4C6p1xnQQ8SpGmB9R6lXGjIIottdjDllfkZhCDmOSFZgx5S8tpvrrF0CVGHNhTJZ/ICQgf3Rz0idW8EGR8HTd/V+LJmOiUfvoTfKxJ+32sULapGLlJebeMbej2AV2AQtF/AGRmnxdgY=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB4642.namprd05.prod.outlook.com (20.177.144.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.16; Mon, 8 Oct 2018 09:56:02 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::e4b8:995b:1c73:657a]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::e4b8:995b:1c73:657a%3]) with mapi id 15.20.1228.020; Mon, 8 Oct 2018
 09:56:02 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 2/5] qtnfmac: use SPDX identifier for pcie bus layer files
Thread-Topic: [PATCH 2/5] qtnfmac: use SPDX identifier for pcie bus layer
 files
Thread-Index: AQHUXu0ebBS98MscAECFA/WI2qIpbg==
Date:   Mon, 8 Oct 2018 09:56:02 +0000
Message-ID: <20181008095551.18651-3-sergey.matyukevich.os@quantenna.com>
References: <20181008095551.18651-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20181008095551.18651-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR02CA0023.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::36) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB4642;6:H52zIc1T0NRJbGJPAJJaHpEIgPtoviRBRIRDdcFNalvSCojpIXBn1FMovZ/OAeVr4hx68GteRXE4HF9SyWzYPabsOuJDu8u9PKpXdmyv7slLzZqNA9/loEnb5sqr0qSWIF1cdbFTW+5hb/AbhliBO/AgmYZVc29Z9p4Rh6yvMnYzLTW6YDV1cFq21NZ47dj0MLrKkrQGqmo6Lk/u4gyWRaYK2dlTUCl/87kUb/ocVBzhT0/iRqnDHB3Ga6xXYCWIJ5NZriKrRcDGmFosEDixlu0t2bdN3sJeWx4Q+Bz6HYupkK98nN22AFFrx6i7FBjqzJ7ZtxxTD9FJnNK/IMf0i8H+KGQJeYKeVq3zkN+VsTdQhqfn6oKXMuttfDfnkMwvhq5PQ+V/sFY7CT6khMeKUfmOCB3QSQ7aVCSM5y255cMOX7Lik1U6I+TCjFdIr7+B1Gl7SBED6vr8lmgI4mpJeA==;5:ZYFwWaLYZZK/+IivMCucSMW6othxXzcoqjaTwszewVDXOBGerSVXeBMgEioXxKB+iOAEna4BY/uFn563jx8y6CiROlpUelQ1IsarYZl3lm+0QIpsPW2cwIUtFKDO+Tu2zNNBemyXVJY135A9xtHWnqMjHfweT6/tiikkg7mEPu4=;7:xzRXrDghJeGkVhmVIGM2CUu5K8UVikoiNJhMlwubPngJJfEVLcOrLU7Rd+HAOqPsn89ID2LuA0TDL28csJL1MPMBuHZBkpkY2M8cwSZRfFIr7w0uPB0DHimvmo3S6sntXcJvWY6v3KxVzepioMPJ0MQSUV5o9jTLtj4YP2FABHDa5EhE66FILqAdtboDGY2CqSZ1vzIMhKhj+7ol6vJI+5AKoWfphxoj67OpVxR2GF8OtnUhcLzMlmfpOlfbtL9G
x-ms-office365-filtering-correlation-id: 9a4e7410-2fce-4d4a-c5db-08d62d044152
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB4642;
x-ms-traffictypediagnostic: BL0PR05MB4642:
x-microsoft-antispam-prvs: <BL0PR05MB4642FA73B1628B5ED89FC297A3E60@BL0PR05MB4642.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(10201501046)(3002001)(93006095)(93001095)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123558120)(20161123564045)(20161123560045)(201708071742011)(7699051);SRVR:BL0PR05MB4642;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB4642;
x-forefront-prvs: 081904387B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39840400004)(396003)(346002)(366004)(376002)(189003)(199004)(105586002)(486006)(68736007)(2351001)(5250100002)(386003)(316002)(2501003)(446003)(2616005)(5660300001)(6916009)(103116003)(186003)(14454004)(53936002)(102836004)(11346002)(3846002)(256004)(305945005)(7736002)(2900100001)(8936002)(106356001)(107886003)(26005)(1076002)(6436002)(54906003)(76176011)(478600001)(6116002)(6486002)(81156014)(25786009)(99286004)(8676002)(81166006)(476003)(52116002)(5640700003)(6506007)(71200400001)(6512007)(71190400001)(2906002)(66066001)(4326008)(86362001)(36756003)(97736004)(2004002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB4642;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: pi4SOj8q1F1U55z4e+vDFwbVdrhVRR+I5rWhn5RQx9pwJnhILou6P/MJPrbPplEx4HUaIrmZlV2tZ/3m3Waa6l6HoW3pHB28Beap2PtWiY5faf3Wyb+o6YAf4wE3MA+8RWWUe7GgPSU0Z1vuxXi0UyBQnyWoj8zoeYQPJnuRCBrNFcEtpDKXaP9kmWfWGeQ8QyOieFeIi1Cvblaaj1PWWjMo4qk2La0SjU+bR3fGgExP45a0p618oAkH5P2K3enQOPZhG9K1GpIXZ7Hu8KzrRsSCdwwRVxptXKeGgmk9KrVqfZAhSrETokPRVfKDbhWxk9B52jLaFj0fZhGDy9TgkcSrN4Iq6+CoJRi9my0xeV8=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a4e7410-2fce-4d4a-c5db-08d62d044152
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2018 09:56:02.0910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB4642
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Change pcie bus layer licensing information to SPDX format.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 .../net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c    | 17 ++-----------=
----
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h    | 17 ++-----------=
----
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie_regs.h   | 17 ++-----------=
----
 3 files changed, 6 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/dri=
vers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index 5aca12a51fe3..95c7b95c6f8a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -1,18 +1,5 @@
-/*
- * Copyright (c) 2015-2016 Quantenna Communications, Inc.
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
+// SPDX-License-Identifier: GPL-2.0+
+/* Copyright (c) 2018 Quantenna Communications */
=20
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h b=
/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
index f21e97ede090..7ecaa69fe018 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
@@ -1,18 +1,5 @@
-/*
- * Copyright (c) 2015-2016 Quantenna Communications, Inc.
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright (c) 2015-2016 Quantenna Communications */
=20
 #ifndef _QTN_FMAC_PCIE_IPC_H_
 #define _QTN_FMAC_PCIE_IPC_H_
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_regs.h =
b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_regs.h
index 0bfe285b6b48..1e6693c17006 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_regs.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_regs.h
@@ -1,18 +1,5 @@
-/*
- * Copyright (c) 2015 Quantenna Communications, Inc.
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright (c) 2015 Quantenna Communications */
=20
 #ifndef __PEARL_PCIE_H
 #define __PEARL_PCIE_H
--=20
2.11.0

