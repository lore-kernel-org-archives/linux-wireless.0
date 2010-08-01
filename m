Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:44431 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab0HAUAV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Aug 2010 16:00:21 -0400
Received: by wwf26 with SMTP id 26so9070126wwf.1
        for <linux-wireless@vger.kernel.org>; Sun, 01 Aug 2010 13:00:19 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 1 Aug 2010 15:59:07 -0400
Message-ID: <AANLkTinU74hoPQ9tfZp12n_rQQX38OYy2qaETON-qGAu@mail.gmail.com>
Subject: Re: SMC 2802W -status unsupported
From: David Cozatt <olbrannon@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

----snip--
If I understand correctly, the device is working - only the wiki is wrong.

For my info, what does 'lspci -nnk | grep 2802' show?

Larry

----/snip--
random david # lspci -nnk | grep 2802
	Subsystem: Standard Microsystems Corp [SMC] SMC2802W Wireless PCI
Adapter [10b8:2802]

One thing only bothers me not sure of wpa2 enough to know if it
matters since I don't use the
wireless-tools to connect but iwconfig reports-

wlan0     IEEE 802.11bg  ESSID:"Davespace"
          Mode:Managed  Frequency:2.437 GHz  Access Point: 00:1C:10:9C:32:87
          Bit Rate=48 Mb/s   Tx-Power=20 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=70/70  Signal level=-1 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

doesn't care? sinde we use wpa? on the enc off?
