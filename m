Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35463 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab0JNQk0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 12:40:26 -0400
Received: by ewy20 with SMTP id 20so3600152ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 09:40:24 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 14 Oct 2010 18:40:14 +0200
Message-ID: <AANLkTinQMRGkOvi4e4JMsHGV_BF_4Rf5oHCtZgQjwQ1g@mail.gmail.com>
Subject: Licensing wlc_phy_radio.h and brcm80211 (was: [PATCH 3/3] b43: N-PHY:
 add 2055 radio regs)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless@vger.kernel.org,
	Henry Ptasinski <henryp@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Nohee Ko <noheek@broadcom.com>,
	Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 11 października 2010 18:24 użytkownik Gábor Stefanik
<netrolller.3d@gmail.com> napisał:
> Doesn't brcm80211 contain register names for B2055?

I've checked brcm80211 and noticed defines in
drivers/staging/brcm80211/phy/wlc_phy_radio.h.

Whole brcm80211 driver is licensed as:
MODULE_LICENSE("Dual BSD/GPL");

Mentioned file contains following comments:
+/*
+ * Copyright (c) 2010 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.

Our b43 driver is licensed as:
MODULE_LICENSE("GPL");
and I am not sure if permission above is actually GPL-compatible. The
best option would be to add defines from wlc_phy_radio.h and include
Broadcom's copyright. However comment above wants us to include info
about free copying/modifying/using which is not GPL-compatible.

Is there any way to solve this issue?

-- 
Rafał
