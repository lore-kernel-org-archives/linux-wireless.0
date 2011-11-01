Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35151 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab1KAUuG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Nov 2011 16:50:06 -0400
Received: by vcge1 with SMTP id e1so6108207vcg.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Nov 2011 13:50:05 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 1 Nov 2011 16:50:05 -0400
Message-ID: <CAJcvjphHr65k6q9vdG9pks=1cCsuE=nP1e-mZKpdL9kH61TV_A@mail.gmail.com> (sfid-20111101_215009_807124_70172977)
Subject: AP mode support for ralink rt2070 vs rt2571W vs rt2573
From: twebb <taliaferro62@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Could someone comment on the current level of AP support for USB-based
drivers: rt2070/2571W/2573 and ath9k_htc?  I'm confused because I
see/read that rt73usb supports AP mode for rt2771W, but I only see USB
DevID for rt2573 (0x2573) listed in rt73usb.c.  What is rt2571W vs
rt2573?

I'm experimenting with USB-based AP functionality and trying to
determine which device(s) to start with.

Thanks,
twebb
