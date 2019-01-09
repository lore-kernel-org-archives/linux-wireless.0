Return-Path: <SRS0=9BuQ=PR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B6C3C43387
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 16:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24A99206BB
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 16:19:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="OP0nw9HB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732683AbfAIQTi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Jan 2019 11:19:38 -0500
Received: from mail-eopbgr710078.outbound.protection.outlook.com ([40.107.71.78]:18263
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732590AbfAIQTi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Jan 2019 11:19:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvyt8Ieq5DDpLx6cdET0V1X4zG8rap9WCdwvQa5Iq4w=;
 b=OP0nw9HBDZQ0ASOv1zxz4NRjS1eiV4LcJY/jlhh8u5rLQmCkly4uBq5N9R0hJbtO7R8ELS63Va4ZEvvBPLuhdBWhnlWNbsZlUSu8B/00WrPzyFqf673Ij11X70YCH8meSxLjWBvB+S6qfJfrds9drNHM+h4SNkkFLi23x1tk5rs=
Received: from MWHPR05MB3406.namprd05.prod.outlook.com (10.174.175.155) by
 MWHPR05MB3455.namprd05.prod.outlook.com (10.174.248.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.9; Wed, 9 Jan 2019 16:19:26 +0000
Received: from MWHPR05MB3406.namprd05.prod.outlook.com
 ([fe80::91e8:d95f:3a8b:6461]) by MWHPR05MB3406.namprd05.prod.outlook.com
 ([fe80::91e8:d95f:3a8b:6461%2]) with mapi id 15.20.1516.010; Wed, 9 Jan 2019
 16:19:26 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5264.namprd05.prod.outlook.com (20.177.252.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.6; Wed, 9 Jan 2019 16:09:04 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5%6]) with mapi id 15.20.1516.010; Wed, 9 Jan 2019
 16:09:04 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 6/7] qtnfmac: convert to SPDX license identifiers
Thread-Topic: [PATCH 6/7] qtnfmac: convert to SPDX license identifiers
Thread-Index: AQHUqDWkiZBF5evYTEWKrejtV7PYJw==
Date:   Wed, 9 Jan 2019 16:09:04 +0000
Message-ID: <20190109160843.14832-7-sergey.matyukevich.os@quantenna.com>
References: <20190109160843.14832-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20190109160843.14832-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0087.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::28) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MWHPR05MB3455;6:JzTeEz/78kLxoa3Q4GbUlJgRQYcUENlMPI9gYlNi/eUfFnKFrcpcMqktJPIPi65nfSiGpgih4laXAPQKVU/YbXA0dfwyHI8f0bXy8Q5pcAqmpIqTULuN+vuVjZrKJSZ77mxsH8LaEensd6Sgcjh/x9phHwU5IG4KA0HxT3V3O/Oed+OnF9PI32VbGrzwbBiQxFAvi7e1QILYk7cCHuN0+GC9TabKPg0YN8Ca2TYgJ5nPMjqwsZ+u687tjLP/OyRSwXBn5QrzBqjQa1jOcAyrq9jUsxfy2uw1fjzb9+0J9RqtYVJEgYqJx9O7+2I2MWXdJS1QaGctrKxqnwzzf/m784r4Y+d8Jsfgtt/bR05ViU+LqtszsiBm1ik2kt35mOTqF/Em5etIr+Bj/MG5sRrkVYeqjJOyOhyTOe/rBnKP9bJpuo4KEfPbp6Q2dfTXXxGdt3lcMXTT0cEzb/b2sNvbww==;5:G4XI61elX+wQG9ikMFyNxiVp/9fKfVsi0vGUm0lfOHO2D7idxgrcYzuEpS5nKEmzEORAgwrF2dlN5sEy4oS1cPMbZxp+RobG3hPeY/EKmHAPS+5wOmgTGzrxkpD5fmJpBm1hnruj10s8p1EUYbgsBLyG855DevlRCAyLB0ItE7CkvrFThAw74juCbuL0NqVRVm8veSaMXca6Wuk+p3f4RQ==;7:rq8J/Ri6JKLQ89Gl9LQvQpEOD9wqGhHE7YifGE1l6cvh4TmlYv/mvvDpr/KJ5u93o2W/YeY1SWpRVtflW7fvb/DIqRrDEWtzieM06GmVGLkAySfTN0hDKyRecICndsJ2rH/KG07vrGPMjh4LT9N+6g==
x-ms-office365-filtering-correlation-id: dbcce310-61fe-432c-f802-08d6764cc678
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5264;
x-ms-traffictypediagnostic: SN6PR05MB5264:|MWHPR05MB3455:
x-moderation-data: 1/9/2019 4:19:23 PM
x-microsoft-antispam-prvs: <MWHPR05MB345575ED92B9E38DF4AB199EA38B0@MWHPR05MB3455.namprd05.prod.outlook.com>
x-forefront-prvs: 0912297777
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(346002)(396003)(376002)(366004)(136003)(189003)(199004)(476003)(86362001)(575784001)(6916009)(446003)(106356001)(6116002)(11346002)(6512007)(486006)(105586002)(6346003)(7736002)(26005)(2616005)(305945005)(5660300001)(386003)(6506007)(8936002)(6436002)(102836004)(107886003)(54906003)(5640700003)(316002)(8676002)(4326008)(81156014)(186003)(81166006)(3846002)(52116002)(71200400001)(103116003)(2351001)(99286004)(53946003)(6486002)(68736007)(53936002)(66066001)(97736004)(256004)(14444005)(25786009)(478600001)(71190400001)(4744004)(436003)(76176011)(1076003)(2906002)(14454004)(36756003)(2501003)(2004002)(579004)(559001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB3455;H:MWHPR05MB3406.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: chE5V58d07HPFtjgz0z5L78lAex8AQwDrlRQ9xjma1C9jgOU2QOCNo0IU5djZMbpzjQEFjl9XsBrhX6wqowrxCc/NWq7E9ZJatU3RoGY5sPeJygA3vr0SujT0JoxcGUXcDamzHJX838NwxGwiyccKajkTyGOKaWBYKNzH6qZNeRUe6/OqItImnmZxwLw5Ftu9G6FOixavuu8Zyjtgrw/oodAIgB7efRRdgwt4lc2ytWf/XH7RXdLl8ybWcSda9Ob1ma1zwfOnFhVl8d3/VTVABsv+roYOXovA7IkPlXl+dmjeqM8xrT3f7NGMAG2E6BT
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbcce310-61fe-432c-f802-08d6764cc678
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2019 16:19:26.0722
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3455
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Replace textual license with SPDX-License-Identifier.
Add an SPDX-License-Identifier for the Makefile.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/Makefile               |  1 +
 drivers/net/wireless/quantenna/qtnfmac/bus.h          | 17 ++-------------=
--
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c     | 17 ++-------------=
--
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.h     |  3 +++
 drivers/net/wireless/quantenna/qtnfmac/commands.c     | 16 ++-------------=
-
 drivers/net/wireless/quantenna/qtnfmac/commands.h     | 16 ++-------------=
-
 drivers/net/wireless/quantenna/qtnfmac/core.c         | 17 ++-------------=
--
 drivers/net/wireless/quantenna/qtnfmac/core.h         | 17 ++-------------=
--
 drivers/net/wireless/quantenna/qtnfmac/debug.c        | 17 ++-------------=
--
 drivers/net/wireless/quantenna/qtnfmac/debug.h        | 17 ++-------------=
--
 drivers/net/wireless/quantenna/qtnfmac/event.c        | 17 ++-------------=
--
 drivers/net/wireless/quantenna/qtnfmac/event.h        | 17 ++-------------=
--
 drivers/net/wireless/quantenna/qtnfmac/qlink.h        | 17 ++-------------=
--
 drivers/net/wireless/quantenna/qtnfmac/qlink_util.c   | 16 ++-------------=
-
 drivers/net/wireless/quantenna/qtnfmac/qlink_util.h   | 17 ++-------------=
--
 drivers/net/wireless/quantenna/qtnfmac/qtn_hw_ids.h   | 17 ++-------------=
--
 drivers/net/wireless/quantenna/qtnfmac/shm_ipc.c      | 17 ++-------------=
--
 drivers/net/wireless/quantenna/qtnfmac/shm_ipc.h      | 17 ++-------------=
--
 drivers/net/wireless/quantenna/qtnfmac/shm_ipc_defs.h | 17 ++-------------=
--
 drivers/net/wireless/quantenna/qtnfmac/trans.c        | 17 ++-------------=
--
 drivers/net/wireless/quantenna/qtnfmac/trans.h        | 17 ++-------------=
--
 drivers/net/wireless/quantenna/qtnfmac/util.c         | 17 ++-------------=
--
 drivers/net/wireless/quantenna/qtnfmac/util.h         | 17 ++-------------=
--
 23 files changed, 46 insertions(+), 312 deletions(-)

diff --git a/drivers/net/wireless/quantenna/Makefile b/drivers/net/wireless=
/quantenna/Makefile
index baebfbde119e..cea83d178d2e 100644
--- a/drivers/net/wireless/quantenna/Makefile
+++ b/drivers/net/wireless/quantenna/Makefile
@@ -1,3 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
 #
 # Copyright (c) 2015-2016 Quantenna Communications, Inc.
 # All rights reserved.
diff --git a/drivers/net/wireless/quantenna/qtnfmac/bus.h b/drivers/net/wir=
eless/quantenna/qtnfmac/bus.h
index 528ca7f5e070..7bd906cc7023 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/bus.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/bus.h
@@ -1,18 +1,5 @@
-/*
- * Copyright (c) 2015 Quantenna Communications
- *
- * Permission to use, copy, modify, and/or distribute this software for an=
y
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIE=
S
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR=
 ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN A=
CTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright (c) 2015 Quantenna Communications. All rights reserved. */
=20
 #ifndef QTNFMAC_BUS_H
 #define QTNFMAC_BUS_H
diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.c
index 422b79a5b98d..e9bef621a7d6 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -1,18 +1,5 @@
-/*
- * Copyright (c) 2012-2012 Quantenna Communications, Inc.
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
+/* Copyright (c) 2015-2016 Quantenna Communications. All rights reserved. =
*/
=20
 #include <linux/kernel.h>
 #include <linux/etherdevice.h>
diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.h
index b73425122a10..7f223d0fbbd3 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h
@@ -1,3 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright (c) 2015-2016 Quantenna Communications. All rights reserved. =
*/
+
 /*
  * Copyright (c) 2015-2016 Quantenna Communications, Inc.
  * All rights reserved.
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.c
index 3f0a0b6abf01..009a4e4f4c7a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -1,17 +1,5 @@
-/*
- * Copyright (c) 2015-2016 Quantenna Communications, Inc.
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
+/* Copyright (c) 2015-2016 Quantenna Communications. All rights reserved. =
*/
=20
 #include <linux/types.h>
 #include <linux/skbuff.h>
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.h b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.h
index 1c25e7905e9a..96dff643bbc4 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.h
@@ -1,17 +1,5 @@
-/*
- * Copyright (c) 2016 Quantenna Communications, Inc.
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
+/* Copyright (c) 2016 Quantenna Communications. All rights reserved. */
=20
 #ifndef QLINK_COMMANDS_H_
 #define QLINK_COMMANDS_H_
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wi=
reless/quantenna/qtnfmac/core.c
index 29258acfa8dc..ee1b75fda1dd 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
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
+/* Copyright (c) 2015-2016 Quantenna Communications. All rights reserved. =
*/
=20
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wi=
reless/quantenna/qtnfmac/core.h
index 293055049caa..a31cff46e964 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
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
+/* Copyright (c) 2015-2016 Quantenna Communications. All rights reserved. =
*/
=20
 #ifndef _QTN_FMAC_CORE_H_
 #define _QTN_FMAC_CORE_H_
diff --git a/drivers/net/wireless/quantenna/qtnfmac/debug.c b/drivers/net/w=
ireless/quantenna/qtnfmac/debug.c
index 9f826b9ef5d9..ad70cdb80060 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/debug.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/debug.c
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
+/* Copyright (c) 2015-2016 Quantenna Communications. All rights reserved. =
*/
=20
 #include "debug.h"
=20
diff --git a/drivers/net/wireless/quantenna/qtnfmac/debug.h b/drivers/net/w=
ireless/quantenna/qtnfmac/debug.h
index d6dd12b5d434..61b45536b83a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/debug.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/debug.h
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
+/* Copyright (c) 2015-2016 Quantenna Communications. All rights reserved. =
*/
=20
 #ifndef _QTN_FMAC_DEBUG_H_
 #define _QTN_FMAC_DEBUG_H_
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/w=
ireless/quantenna/qtnfmac/event.c
index 8b542b431b75..3038a000c287 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
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
+/* Copyright (c) 2015-2016 Quantenna Communications. All rights reserved. =
*/
=20
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.h b/drivers/net/w=
ireless/quantenna/qtnfmac/event.h
index ae759b602c2a..533ad99d045d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.h
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
+/* Copyright (c) 2015-2016 Quantenna Communications. All rights reserved. =
*/
=20
 #ifndef _QTN_FMAC_EVENT_H_
 #define _QTN_FMAC_EVENT_H_
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/w=
ireless/quantenna/qtnfmac/qlink.h
index ace52e9d421d..d958b268de02 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
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
+/* Copyright (c) 2015-2016 Quantenna Communications. All rights reserved. =
*/
=20
 #ifndef _QTN_QLINK_H_
 #define _QTN_QLINK_H_
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c b/drivers/=
net/wireless/quantenna/qtnfmac/qlink_util.c
index aeeda81b09ea..72bfd17cb687 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
@@ -1,17 +1,5 @@
-/*
- * Copyright (c) 2015-2016 Quantenna Communications, Inc.
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
+/* Copyright (c) 2015-2016 Quantenna Communications. All rights reserved. =
*/
=20
 #include <linux/nl80211.h>
=20
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h b/drivers/=
net/wireless/quantenna/qtnfmac/qlink_util.h
index fc87827cb49c..781ea7fe79f2 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
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
+/* Copyright (c) 2015-2016 Quantenna Communications. All rights reserved. =
*/
=20
 #ifndef _QTN_FMAC_QLINK_UTIL_H_
 #define _QTN_FMAC_QLINK_UTIL_H_
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qtn_hw_ids.h b/drivers/=
net/wireless/quantenna/qtnfmac/qtn_hw_ids.h
index 40295a511224..82d879950b62 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qtn_hw_ids.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qtn_hw_ids.h
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
+/* Copyright (c) 2015-2016 Quantenna Communications. All rights reserved. =
*/
=20
 #ifndef	_QTN_HW_IDS_H_
 #define	_QTN_HW_IDS_H_
diff --git a/drivers/net/wireless/quantenna/qtnfmac/shm_ipc.c b/drivers/net=
/wireless/quantenna/qtnfmac/shm_ipc.c
index 2ec334199c2b..ff678951d3b2 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/shm_ipc.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/shm_ipc.c
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
+/* Copyright (c) 2015-2016 Quantenna Communications. All rights reserved. =
*/
=20
 #include <linux/types.h>
 #include <linux/io.h>
diff --git a/drivers/net/wireless/quantenna/qtnfmac/shm_ipc.h b/drivers/net=
/wireless/quantenna/qtnfmac/shm_ipc.h
index c2a3702a9ee7..52cac5439b03 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/shm_ipc.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/shm_ipc.h
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
+/* Copyright (c) 2015-2016 Quantenna Communications. All rights reserved. =
*/
=20
 #ifndef _QTN_FMAC_SHM_IPC_H_
 #define _QTN_FMAC_SHM_IPC_H_
diff --git a/drivers/net/wireless/quantenna/qtnfmac/shm_ipc_defs.h b/driver=
s/net/wireless/quantenna/qtnfmac/shm_ipc_defs.h
index 95a5f89a8b1a..78be70df1218 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/shm_ipc_defs.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/shm_ipc_defs.h
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
+/* Copyright (c) 2015-2016 Quantenna Communications. All rights reserved. =
*/
=20
 #ifndef _QTN_FMAC_SHM_IPC_DEFS_H_
 #define _QTN_FMAC_SHM_IPC_DEFS_H_
diff --git a/drivers/net/wireless/quantenna/qtnfmac/trans.c b/drivers/net/w=
ireless/quantenna/qtnfmac/trans.c
index 345f34ec9750..95356e280e23 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/trans.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/trans.c
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
+/* Copyright (c) 2015-2016 Quantenna Communications. All rights reserved. =
*/
=20
 #include <linux/types.h>
 #include <linux/export.h>
diff --git a/drivers/net/wireless/quantenna/qtnfmac/trans.h b/drivers/net/w=
ireless/quantenna/qtnfmac/trans.h
index 9a473e07af0f..c0b76f871b31 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/trans.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/trans.h
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
+/* Copyright (c) 2015-2016 Quantenna Communications. All rights reserved. =
*/
=20
 #ifndef _QTN_FMAC_TRANS_H_
 #define _QTN_FMAC_TRANS_H_
diff --git a/drivers/net/wireless/quantenna/qtnfmac/util.c b/drivers/net/wi=
reless/quantenna/qtnfmac/util.c
index 3bc96b264769..cda6f5f3f38a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/util.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/util.c
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
+/* Copyright (c) 2015-2016 Quantenna Communications. All rights reserved. =
*/
=20
 #include "util.h"
 #include "qtn_hw_ids.h"
diff --git a/drivers/net/wireless/quantenna/qtnfmac/util.h b/drivers/net/wi=
reless/quantenna/qtnfmac/util.h
index b8744baac332..a14b7078a9c7 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/util.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/util.h
@@ -1,18 +1,5 @@
-/*
- * Copyright (c) 2015 Quantenna Communications
- *
- * Permission to use, copy, modify, and/or distribute this software for an=
y
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIE=
S
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR=
 ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN A=
CTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright (c) 2015 Quantenna Communications. All rights reserved. */
=20
 #ifndef QTNFMAC_UTIL_H
 #define QTNFMAC_UTIL_H
--=20
2.11.0

