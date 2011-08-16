Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout9.freenet.de ([195.4.92.99]:52652 "EHLO mout9.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab1HPUDO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 16:03:14 -0400
Message-ID: <4E4ACD10.7000807@01019freenet.de> (sfid-20110816_220318_614153_C0B57DB8)
Date: Tue, 16 Aug 2011 22:03:28 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Ivo Van Doorn <ivdoorn@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 7 more packets after each beacon frame
References: <4E4AB695.5070300@01019freenet.de> <CAOZOX0UsRxT9ECdUC7OL2toJUb+PitGhxCifTyD8hWYwt6R_zg@mail.gmail.com>
In-Reply-To: <CAOZOX0UsRxT9ECdUC7OL2toJUb+PitGhxCifTyD8hWYwt6R_zg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo Van Doorn schrieb:
> Hi,
> 
>> When examining my own AP (rt2860 based) with another STA in monitor
>> mode, I can see always 7 packets after each beacon frame:
> 
> Well if it is an AP with a rt2860 chipset, then it probably isn't
> using the rt2x00 drivers,

I'm using rt2800pci driver (from compat-wireless-2011-08-08).


Aug 16 20:33:24 pc kernel: [52436.719073] cfg80211: Calling CRDA to
update world regulatory domain
Aug 16 20:33:24 pc kernel: [52436.740378] cfg80211: World regulatory
domain updated:
Aug 16 20:33:24 pc kernel: [52436.740383] cfg80211:     (start_freq -
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Aug 16 20:33:24 pc kernel: [52436.740386] cfg80211:     (2402000 KHz -
2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 16 20:33:24 pc kernel: [52436.740389] cfg80211:     (2457000 KHz -
2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Aug 16 20:33:24 pc kernel: [52436.740391] cfg80211:     (2474000 KHz -
2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Aug 16 20:33:24 pc kernel: [52436.740393] cfg80211:     (5170000 KHz -
5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 16 20:33:24 pc kernel: [52436.740396] cfg80211:     (5735000 KHz -
5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 16 20:33:24 pc kernel: [52436.750023] cfg80211: Calling CRDA for
country: DE
Aug 16 20:33:24 pc kernel: [52436.756976] cfg80211: Regulatory domain
changed to country: DE
Aug 16 20:33:24 pc kernel: [52436.756981] cfg80211:     (start_freq -
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Aug 16 20:33:24 pc kernel: [52436.756983] cfg80211:     (2400000 KHz -
2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
Aug 16 20:33:24 pc kernel: [52436.756986] cfg80211:     (5150000 KHz -
5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Aug 16 20:33:24 pc kernel: [52436.756988] cfg80211:     (5470000 KHz -
5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
Aug 16 20:33:24 pc kernel: [52436.825208] rt2800pci 0000:03:07.0: PCI
INT A -> GSI 21 (level, low) -> IRQ 21
Aug 16 20:33:24 pc kernel: [52436.835011] phy0 -> rt2x00_set_chip: Info
- Chipset detected - rt: 2860, rf: 0002, rev: 0103.
Aug 16 20:33:24 pc kernel: [52436.844383] ieee80211 phy0: Selected rate
control algorithm 'minstrel_ht'
Aug 16 20:33:24 pc kernel: [52436.845258] Registered led device:
rt2800pci-phy0::radio
Aug 16 20:33:24 pc kernel: [52436.845276] Registered led device:
rt2800pci-phy0::assoc
Aug 16 20:33:24 pc kernel: [52436.845293] Registered led device:
rt2800pci-phy0::quality
Aug 16 20:33:24 pc kernel: [52436.863893] udev: renamed network
interface wlan0 to wlan1
Aug 16 20:33:24 pc ifup:     wlan1     device: RaLink RT2800 802.11n PCI
Aug 16 20:33:24 pc ifup:               No configuration found for wlan1
Aug 16 20:33:26 pc kernel: [52438.868947] phy0 ->
rt2x00lib_request_firmware: Info - Loading firmware file 'rt2860.bin'.
Aug 16 20:33:26 pc kernel: [52438.873544] phy0 ->
rt2x00lib_request_firmware: Info - Firmware detected - version: 0.34.
Aug 16 20:33:26 pc kernel: [52438.900652] phy0 -> rt2800pci_mcu_status:
Error - MCU request failed, no response from hardware
Aug 16 20:33:26 pc kernel: [52438.907351] phy0 -> rt2x00mac_conf_tx:
Info - Configured TX queue 0 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 102.
Aug 16 20:33:26 pc kernel: [52438.907373] phy0 -> rt2x00mac_conf_tx:
Info - Configured TX queue 1 - CWmin: 4, CWmax: 5, Aifs: 2, TXop: 188.
Aug 16 20:33:26 pc kernel: [52438.907390] phy0 -> rt2x00mac_conf_tx:
Info - Configured TX queue 2 - CWmin: 5, CWmax: 10, Aifs: 3, TXop: 0.
Aug 16 20:33:26 pc kernel: [52438.907407] phy0 -> rt2x00mac_conf_tx:
Info - Configured TX queue 3 - CWmin: 5, CWmax: 10, Aifs: 7, TXop: 0.


> so no idea what those extra frames would be.

They are coming up exactly with the starting of hostapd.

> Can't they come from another client somewhere which is responding to the AP?

None of my clients have been running as supplicant during the
measurement. There can't be seen any MAC or IP addresses in this
package. But they're sent on exactly this channel the AP (hostapd) is
configured on.


Andreas
