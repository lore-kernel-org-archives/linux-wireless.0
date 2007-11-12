Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:24010 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758439AbXKLNsz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2007 08:48:55 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1476773fkz
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2007 05:48:54 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 0/3] rt2x00
Date: Mon, 12 Nov 2007 15:02:01 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711121502.01953.IvDoorn@gmail.com> (sfid-20071112_134900_332719_D38D27BD)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is a minor update for rt2x00, no version bump this time since
the number of patches is so limited. If possible queue these for 2.6.24.

The first one fixes a bug in the chipset revision detection, where devices
were being accepted by the rt2500usb driver while they should be dropped
(in favour of rt73usb).

The second patch is code cleaning, but the third patch depends on this one.
Finally the first patch fixes the dreadfull "non-free entry in the non-full queue"
queue messages which effectively resulted in the TX shutting down comlpletely
with rt61pci.

Ivo
