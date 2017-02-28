Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f169.google.com ([74.125.82.169]:33431 "EHLO
        mail-ot0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751720AbdB1Ufy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Feb 2017 15:35:54 -0500
Received: by mail-ot0-f169.google.com with SMTP id k4so15974350otc.0
        for <linux-wireless@vger.kernel.org>; Tue, 28 Feb 2017 12:35:48 -0800 (PST)
MIME-Version: 1.0
From: Senthilganapathy Paramasivam <senthilgp2020@gmail.com>
Date: Tue, 28 Feb 2017 14:02:35 -0600
Message-ID: <CAPK922czwT9jmpkn0xXGJxwL74hzsKWjxkYEhZf15v2oHKPV3g@mail.gmail.com> (sfid-20170228_213635_482599_44FB001D)
Subject: ath9k driver : Support for Continuous Test Tone mode
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi ,
One of our wireless embedded product is operating on Linux Kernel : 3.12.19.

This product has a 802.11 a/b/g/n Full-size Mini PCIe Card
EWM-W158F01E Which is based on atheros AR9592-AR1B Chipset. ath9k
driver supports this chip set.

One of the compliance testing requirement is :
In the minimum transfer rate for power measurements, and at the
maximum rate for the other measurements, with the transmitter
operating with continuous transmission.

I am looking for the test mode support in ath9k driver and user space
utility to invoke the test mode.

1. Configuring the atheros 9k driver in CONFIG_ATH9K_TX99 test mode
https://github.com/torvalds/linux/commit/ef6b19e40f525777a0052956bf7d9a1985f74993
as per the log message the supported kernel is from 3.14-rc1
Latest Kernel 3.12.70 also does not have support for TX99 mode.

2. User space utility to send the continuous tone
Some of the references using a special tool called Atheros test tool
for the user space utility.
  There is a reference to a windows based utility "Atheros Radio test tool".
  Some documents refer to linux based atheros test tool but they are
based on wireless extensions.
  Searching for a similar utility did not yield any results.

Any pointers are welcome.

Thanks
Senthil
