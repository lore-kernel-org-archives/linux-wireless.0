Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58596 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934780Ab2C3VEz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 17:04:55 -0400
Received: by wgbdr13 with SMTP id dr13so942409wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Mar 2012 14:04:53 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 30 Mar 2012 16:04:53 -0500
Message-ID: <CAJ8GFOihCt_JBPoawk2xKOO6wan_03F9LLwhsOAbmAKXSs0ygg@mail.gmail.com> (sfid-20120331_010503_460038_1BE7BA9D)
Subject: Dual-band support for AP mode for AR9280?
From: Harshal Chhaya <harshal@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

The 'ath9k' project page
(http://linuxwireless.org/en/users/Drivers/ath9k) mentions that '2x2
DB 11n' operation is supported for AR9280. A later section says that
'AP mode' is supported.

Does the AP mode support full 11n features in a dual-band
configuration? Is there a hard limit to the number of clients when the
AR9280 is used as an AP? I am currently using an AR9170 (using
carl9170 - thanks, Christian) as an AP and found that I had to switch
to software encryption to scale beyond 32 clients because of the
number of key slots on the chip.

And are the numbers in the 'power consumption' analysis
(http://linuxwireless.org/en/users/Drivers/ath9k/power-consumption)
for STA mode or AP mode? The 'PS On' configuration implies that this
is for an STA mode but I wanted to confirm.

Thanks,
- Harshal
