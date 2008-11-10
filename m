Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:25423 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbYKJSmb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 13:42:31 -0500
Received: by ey-out-2122.google.com with SMTP id 6so997729eyi.37
        for <linux-wireless@vger.kernel.org>; Mon, 10 Nov 2008 10:42:29 -0800 (PST)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 2/2] rt2x00: Move rt73usb register access wrappers into rt2x00usb
Date: Mon, 10 Nov 2008 19:42:18 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200811101941.40391.IvDoorn@gmail.com>
In-Reply-To: <200811101941.40391.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811101942.18478.IvDoorn@gmail.com> (sfid-20081110_194238_023344_8ECC0E8C)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2500usb and rt73usb have different register word sizes,
for that reason the register access wrappers were never
moved into rt2x00usb.
With rt2800usb on its way, we should favor the 32bit
register access and move those wrappers into rt2x00usb.
That saves duplicate code, since only rt2500usb will
need the special 16bit wrappers.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
http://kernel.org/pub/linux/kernel/people/ivd/patches/0002-rt2x00-Move-rt73usb-register-access-wrappers-into-r.patch


