Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dnvrco-outbound-snat.email.rr.com ([107.14.73.232]:7347 "EHLO
        dnvrco-cmomta02.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751269AbeEVR3h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 13:29:37 -0400
Message-ID: <20180522172129.V9LI1.34449.root@dnvrco-web11> (sfid-20180522_192940_596488_9AB58461)
Date: Tue, 22 May 2018 17:21:29 +0000
From: <mgreger@cinci.rr.com>
To: linux-wireless@vger.kernel.org
Subject: Atheros AR9462 - 5Ghz not working
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've run out of ideas and am hoping someone here can help.

All I want to do is connect a client to my 5Ghz network.

My client:
  OS is Debian stable "Stretch" with sysvinit instead of systemd
  Atheros AR9462 (World roaming 0x64 regdomain in EEPROM) 
  "iw reg set US"
  "iw list" shows both 2.4Ghz and 5Ghz bands available.
  "iw wlp3s0 survey dump" shows received traffic on 5Ghz bands.

There are oodles of 5Ghz AP's within range, but scans (including passive scans) reveal only 2.4Ghz networks. My only guess was that it won't transmit due to regulatory requirements, but I cannot make it work. 

What I've tried:
  Running with and without CRDA
  Running latest mainline kernel
  Hacking around on the ath9k driver and nl80211 to remove all regulatory enforcement.

Nothing works and I'm pulling my hair out. Any help would be greatly appreciated.
