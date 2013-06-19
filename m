Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [78.193.33.39] ([78.193.33.39]:45960 "EHLO qult.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935087Ab3FSTd0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 15:33:26 -0400
Date: Wed, 19 Jun 2013 21:33:17 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Corey Richardson <corey@octayn.net>
Subject: Re: [ath9k-devel] ath9k_htc: station unable to authenticate
Message-ID: <20130619193316.GA29582@zenon.in.qult.net> (sfid-20130619_213329_977491_F6EB323D)
References: <20130619115809.GA26717@zenon.in.qult.net>
 <51C1ACEC.2020703@rempel-privat.de>
 <1DC40B07CD6EC041A66726C271A73AE61AA312F5@IRSMSX102.ger.corp.intel.com>
 <51C1B467.1030509@rempel-privat.de>
 <20130619140905.GA14079@zenon.in.qult.net>
 <1371651073.8349.19.camel@jlt4.sipsolutions.net>
 <51C1C95C.8030301@rempel-privat.de>
 <20130619175939.GA19405@zenon.in.qult.net>
 <20130619180354.GB19405@zenon.in.qult.net>
 <51C1FA76.3090109@rempel-privat.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51C1FA76.3090109@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 19, 2013 at 08:37:42PM +0200, thus spake Oleksij Rempel:
> Can you please tell more about your access point:
> - hardware
> - firmware
> - configuration
> - "iw dev wlan0 scan dump"

I tested the thing with at least three different APs:

  - Netgear DG834Gv4 with latest firmware.
  - Netgear DG834Gv5 (don't know which firmware and can't check at this time).
  - hostapd (can't say which version at this time either) with the same
    ath9k_htc.

All APs are configured for WPA2-PSK.

The scan dump for the first AP:

BSS 00:1e:2a:ed:35:70 (on wlan7)
        TSF: 163623606 usec (0d, 00:02:43)
        freq: 2412
        beacon interval: 100
        capability: ESS Privacy ShortSlotTime (0x0411)
        signal: -43.00 dBm
        last seen: 24 ms ago
        Information elements from Probe Response frame:
        SSID: Wolfnet
        Supported rates: 1.0* 2.0* 5.5* 11.0* 18.0 24.0 36.0 54.0 
        DS Parameter set: channel 1
        ERP: Barker_Preamble_Mode
        RSN:     * Version: 1
                 * Group cipher: CCMP
                 * Pairwise ciphers: CCMP
                 * Authentication suites: PSK
                 * Capabilities: 16-PTKSA-RC (0x000c)
        Extended supported rates: 6.0 9.0 12.0 48.0 
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec

-- 
Save the whales. Feed the hungry. Free the mallocs. 
