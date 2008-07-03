Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:28800 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbYGCPqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 11:46:22 -0400
Received: by yx-out-2324.google.com with SMTP id 8so275090yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jul 2008 08:46:21 -0700 (PDT)
To: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: [ANN] rt2800 development
Date: Thu, 3 Jul 2008 17:51:27 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807031751.27838.IvDoorn@gmail.com> (sfid-20080703_174700_358783_8F6CEB45)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have promised time and time again work for rt2860/rt2870 is underway,
and although rt2x00.git contained a base for this work for quite some time
already, development of those drivers have been halted during the past
months.

I can now announce that as of next week the real development on rt2800
will begin. The current base will be refactored for the past changes in rt2x00
(like the recent DMA changes), and will be extended afterwards.

This also means rt2x00lib will be updated for 802.11n support, and the
current HW crypto implementation must be tested to see if at least the
rt2x00lib part of that code is correct so it can be used for rt2800 safely.

The goal will be to have a testable driver before the end of this month,
and hopefully a stable driver early September. Plans for kernel integration
can be made when the driver is under testing, so I won't make any
speculations about that right now.

Ivo
