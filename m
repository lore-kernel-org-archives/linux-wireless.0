Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50223 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab1GNTh3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 15:37:29 -0400
Received: by vws1 with SMTP id 1so429592vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jul 2011 12:37:29 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 14 Jul 2011 14:37:29 -0500
Message-ID: <CAJ8GFOiTwtS7Ddjo8GR3uJMFtkBY+cFuNo3d4mX_4EwOLN9PxQ@mail.gmail.com> (sfid-20110714_213732_884872_B5617925)
Subject: carl9170: Beacons at lower Tx power than data frames?
From: Harshal Chhaya <harshal@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am working on an AP design that uses a TI-OMAP3 host processor with
an Atheros AR9170 + AR9101 WLAN chipset. We are currently using
carl9170 version 1.9.2 and carl9170 firmware version 1.9.4.

During network tests, several of the clients drop-off the network. The
packet captures show that the beacons sent by the AP are at a much
lower power than the other data packets. For example, the beacons are
typically at -75 dbm while the data packets are at -54 dbm or better.
The power for all packets ranges from -99dBm to -45dbm at a sniffer
(Omnipeek) sitting about 4 ft away.

One theory is that the clients are missing enough beacons that they
assume that they are disconnected.

Is this wide variation in the AP's transmit power the expected
behavior with this driver/firmware/chipset? If not, where do I look to
fix this.

Thanks,
- Harshal
