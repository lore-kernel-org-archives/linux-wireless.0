Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:34074 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbZDZONZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Apr 2009 10:13:25 -0400
Received: by ey-out-2122.google.com with SMTP id 9so452710eyd.37
        for <linux-wireless@vger.kernel.org>; Sun, 26 Apr 2009 07:13:24 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 5/5] rt2x00: Implement support for rt2800usb
Date: Sun, 26 Apr 2009 16:11:07 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
References: <200904261608.30384.IvDoorn@gmail.com> <200904261609.11447.IvDoorn@gmail.com> <200904261609.32275.IvDoorn@gmail.com>
In-Reply-To: <200904261609.32275.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200904261611.07752.IvDoorn@gmail.com> (sfid-20090426_161334_041619_2E7BB75D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for the rt2800usb chipset.

Current problems:
 * Cannot scan 11n AP's
 * No TX during first minute after association
 * Broken Hardware encryption

Includes various patches from Mattias, Felix, Xose and Axel.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Axel Kollhofer <rain_maker@root-forum.org>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
http://kernel.org/pub/linux/kernel/people/ivd/patches/0005-rt2x00-Implement-support-for-rt2800usb.patch
