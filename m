Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44346 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab0KVSl7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 13:41:59 -0500
Received: by vws13 with SMTP id 13so3608343vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 10:41:59 -0800 (PST)
Message-ID: <4CEAB969.20702@lwfinger.net>
Date: Mon, 22 Nov 2010 12:41:45 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: b43 error under heavy load
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael,

Under heavy load with multiple streams, I'm getting errors from my BCM4312
(14e4:4315) device as follows:

b43-phy0 debug: TX-status contains invalid cookie: 0x0D4D
b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 74, but got 76
b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 74, but got 78
(and continues).

Clearly that cookie is garbage as it has a slot number of 0. Any suggestions on
diagnostic information that I could dump to help debug this?

Thanks,

Larry
