Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:52303 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbYDUPiT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 11:38:19 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Jny5t-0002vK-79
	for linux-wireless@vger.kernel.org; Mon, 21 Apr 2008 15:38:13 +0000
Received: from port-87-193-186-180.static.qsc.de ([87.193.186.180])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 15:38:13 +0000
Received: from thomas by port-87-193-186-180.static.qsc.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 15:38:13 +0000
To: linux-wireless@vger.kernel.org
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: [ipw3945-devel] iwl3945: Disabled channels
Date: Mon, 21 Apr 2008 17:38:03 +0200
Message-ID: <fuiccr$keo$1@ger.gmane.org> (sfid-20080421_173908_753289_77443476)
References: <fuhkfp$mnk$1@ger.gmane.org> <480C5AFF.5020005@fenrir.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
In-Reply-To: <480C5AFF.5020005@fenrir.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Morrison schrieb:
> options cfg80211 ieee80211_regdom="JP"

Band 1:
	Frequencies:
		* 2412 MHz
		* 2417 MHz
		* 2422 MHz
		* 2427 MHz
		* 2432 MHz
		* 2437 MHz
		* 2442 MHz
		* 2447 MHz
		* 2452 MHz
		* 2457 MHz
		* 2462 MHz
		* 2467 MHz (passive scanning, no IBSS)
		* 2472 MHz (passive scanning, no IBSS)
	Bitrates:
		* 1.0 Mbps
		* 2.0 Mbps (short preamble supported)
		* 5.5 Mbps (short preamble supported)
		* 11.0 Mbps (short preamble supported)
		* 6.0 Mbps
		* 9.0 Mbps
		* 12.0 Mbps
		* 18.0 Mbps
		* 24.0 Mbps
		* 36.0 Mbps
		* 48.0 Mbps
		* 54.0 Mbps
Band 2:
	Frequencies:
		* 5170 MHz (passive scanning, no IBSS)
		* 5180 MHz
		* 5190 MHz (passive scanning, no IBSS)
		* 5200 MHz
		* 5210 MHz (passive scanning, no IBSS)
		* 5220 MHz
		* 5230 MHz (passive scanning, no IBSS)
		* 5240 MHz
		* 5260 MHz (passive scanning, no IBSS, radar detection)
		* 5280 MHz (passive scanning, no IBSS, radar detection)
		* 5300 MHz (passive scanning, no IBSS, radar detection)
		* 5320 MHz (passive scanning, no IBSS, radar detection)
		* 5500 MHz (disabled, passive scanning, no IBSS, radar detection)
		* 5520 MHz (disabled, passive scanning, no IBSS, radar detection)
		* 5540 MHz (disabled, passive scanning, no IBSS, radar detection)
		* 5560 MHz (disabled, passive scanning, no IBSS, radar detection)
		* 5580 MHz (disabled, passive scanning, no IBSS, radar detection)
		* 5600 MHz (disabled, passive scanning, no IBSS, radar detection)
		* 5620 MHz (disabled, passive scanning, no IBSS, radar detection)
		* 5640 MHz (disabled, passive scanning, no IBSS, radar detection)
		* 5660 MHz (disabled, passive scanning, no IBSS, radar detection)
		* 5680 MHz (disabled, passive scanning, no IBSS, radar detection)
		* 5700 MHz (disabled, passive scanning, no IBSS, radar detection)
	Bitrates:
		* 6.0 Mbps
		* 9.0 Mbps
		* 12.0 Mbps
		* 18.0 Mbps
		* 24.0 Mbps
		* 36.0 Mbps
		* 48.0 Mbps
		* 54.0 Mbps

This look better, although I have to wait until tomorrow to see if the 
Access Point in question uses one of the now enabled 11a channels.

