Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2073DC43387
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0C4920659
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:41:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="u3e92MTD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbfANJlA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Jan 2019 04:41:00 -0500
Received: from mail-eopbgr790089.outbound.protection.outlook.com ([40.107.79.89]:22134
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726534AbfANJk7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Jan 2019 04:40:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/FifbCwV/SaXGnn4rnwOaTkcN2wD8lrvnS1KlYdtryQ=;
 b=u3e92MTDe15+uAvYdWLQ7EMWUT5BmXN5szqg11po0iFYPnHI2T4er1wzqu2HUMq7kWtWg37uFp7dOCdXK9QrFG7oQJ1ALudzIUEHWWlp8/FgoCdhxX/+HTpgGyYzrW4XFNdNPN65quBQgV4yWzmtLQka0NP6/cOVQy9370bHNhY=
Received: from BYAPR05MB4423.namprd05.prod.outlook.com (52.135.202.161) by
 BYAPR05MB5782.namprd05.prod.outlook.com (20.178.48.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.18; Mon, 14 Jan 2019 09:40:46 +0000
Received: from BYAPR05MB4423.namprd05.prod.outlook.com
 ([fe80::3158:fd7e:cb38:19d0]) by BYAPR05MB4423.namprd05.prod.outlook.com
 ([fe80::3158:fd7e:cb38:19d0%2]) with mapi id 15.20.1537.018; Mon, 14 Jan 2019
 09:40:46 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4719.namprd05.prod.outlook.com (52.135.114.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.17; Mon, 14 Jan 2019 09:39:45 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5%6]) with mapi id 15.20.1537.018; Mon, 14 Jan 2019
 09:39:45 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 6/9] qtnfmac: convert to SPDX license identifiers
Thread-Topic: [PATCH v2 6/9] qtnfmac: convert to SPDX license identifiers
Thread-Index: AQHUq+0VJiWGpbm8YUSFxlO1GTcI7g==
Date:   Mon, 14 Jan 2019 09:39:45 +0000
Message-ID: <20190114093925.9061-7-sergey.matyukevich.os@quantenna.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR05MB5782;6:4E8hReGdZv6vOwCvGPDBsSGaH/1mREDWb9AP2P6bZ9ts5Qy/rS037/W+4SjgjKwgkkMpuOYmtXT3TQapYaSJMFsoX91GymG4+06WN7Jm3+IS4VVT8X+eSvFAFnWir1BJPcy4V/bJkX5+JoU8/U6D+kLO8zSx7zm9/YxMIPS66tbDwazYXSod4ItQ6ke/TJQz/nrTcP27wD2YxlsCjcFGtx632M1v8Qn7Km9DlBG/8AL80sRbbZ0htJU1iLk4c8LWYlykZixao6Y37t8fMAkVJnftcZcEE0h570K8XcJnlw+4jNH0QziVQ5J656YtPMqcShN6UGf7PzRotk0leUQWkvfw9j8vYYie4wcczDST+ZAyNUlWVylb1kwyTiaeq1mAqG3FNGVf5dhDb7y6MlqCkD70EAEhvjj0XHlTu6K54ltG6F37AEQ+chsj8LtE5e0+O2CrPmz0Piopfq5SgOE+Ng==;5:oS5AgmUQ0dINpHME+JjjOb82KAX0saSEueSyE2mz+lYoM5bprtwoFWFV0jAxVS5dqTy7LaAT/08jUc65vl/esaHbSsBr0O8NTG+iD8Le0pExoMy4YptQbfXsauORM7JVdoP/4tXCeXlQRNger96ClY+irOZuCf9cMFFe8QldjZb3swHhqFdJGPW2d0E3XmkyCd/R15aHUaGAwH0Yr1zXoQ==;7:d5CMz53sYhwGcjapQcoCC+kIdoQmTGdAuSgITx6o6tvOtUAoVyspfpwCl40wbRl+LEEjRuJEcebtqE6brM58OjMAOlgjY772hCn6FAKwQl07fIUwXZCrkhPq+/0GJ9atMSh0D7WUy2h2cVwIFyFHfg==
x-ms-office365-filtering-correlation-id: c2c5d17d-2ad1-4c2d-61fe-08d67a043721
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600109)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB4719;
x-ms-traffictypediagnostic: SN6PR05MB4719:|BYAPR05MB5782:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-moderation-data: 1/14/2019 9:40:45 AM
x-microsoft-antispam-prvs: <BYAPR05MB5782FE09500BDB8AA2796972A3800@BYAPR05MB5782.namprd05.prod.outlook.com>
x-forefront-prvs: 0917DFAC67
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(366004)(39840400004)(396003)(136003)(199004)(189003)(105586002)(305945005)(8936002)(6916009)(486006)(7736002)(5660300001)(2616005)(81166006)(81156014)(71190400001)(71200400001)(1076003)(30864003)(256004)(11346002)(8676002)(14444005)(446003)(476003)(106356001)(436003)(575784001)(6116002)(68736007)(86362001)(2906002)(186003)(6486002)(3846002)(14454004)(2501003)(107886003)(53936002)(102836004)(52116002)(97736004)(6436002)(54906003)(5640700003)(316002)(26005)(53946003)(76176011)(103116003)(36756003)(25786009)(66066001)(99286004)(478600001)(6512007)(2351001)(4326008)(386003)(6506007)(2004002)(559001)(579004);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB5782;H:BYAPR05MB4423.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: T1qaM8DLaEm8K3bcuUjzLgVMDE1ISUedwAOybny5GvdTcuwpS8ml/Y1cFEtbWcU2xFBlHX872k91/FA6resJbwERgwXFzQpr9B59mp2UvVrUVSGUGvy8ye3WRcK+YMHcfl7gCvcNxMdB7E+XXWVFJtcRH/WRl7LTQI4pIqa05RaTJCVsnsl8ER+SdlslggC7wrcs1XF2o0KFHYSs77DPR+JOIiVOuflVExROuzl7r6NNVlyLy7Psma+B7PC8c8uSUdYOa8LS+DHoJe4AuIOGGf+YzaAT/9kEG1A9oOxYFBQofsCYqM/NEEP4R4b/N1mXmB1LxpYvE//+0xSR75ycaG/iyc2Ueg3JNwtUpNOm2C3CQsvJ6SEB6YyVJBEF63DY/stBKlMWh16Qp+uZ8GYA5OqzRgAD3lrSgAiX9CcNKsk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2c5d17d-2ad1-4c2d-61fe-08d67a043721
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2019 09:40:46.7954
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5782
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
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.h     | 17 ++-------------=
--
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
 23 files changed, 45 insertions(+), 327 deletions(-)

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
index 1b02096934f8..45f4cef7de9c 100644
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
index b73425122a10..c374857283ac 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h
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
 #ifndef _QTN_FMAC_CFG80211_H_
 #define _QTN_FMAC_CFG80211_H_
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

