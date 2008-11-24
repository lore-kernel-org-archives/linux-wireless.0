Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39650 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbYKXSzJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 13:55:09 -0500
Subject: Re: ath5k: can't browse at all.
From: Dan Williams <dcbw@redhat.com>
To: Irwan Siajadi <dev.bahamot@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <978525.69086.qm@web59613.mail.ac4.yahoo.com>
References: <978525.69086.qm@web59613.mail.ac4.yahoo.com>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 13:54:32 -0500
Message-Id: <1227552872.25089.3.camel@localhost.localdomain> (sfid-20081124_195514_281725_3D613548)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-11-24 at 09:41 -0800, Irwan Siajadi wrote:
> The AR2425 is able to obtain IP address from the router, 
> able to ping with good results, but can't browse at all.
> Below are the info on my setup, if you need more info please let me know.

Can you traceroute to some IP, say like 4.2.2.1 or 4.2.2.2?

Dan

> Driver version: compat-wireless-2008-11-24.tar.bz2.
> Kernel: 2.6.27.4-2mnbcustom (mandriva), compiled with mandriva provided 
> ..config but without any WLAN support except WIRELESS_EXT.
> Access point/router is configured to use channel 1 (2.412GHz).
> 
> dmesg:
> "...
> cfg80211: Using static regulatory domain info
> cfg80211: Regulatory domain: JP
>           (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>           (2402000 KHz - 2494000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
>           (5160000 KHz - 5250000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
>           (5250000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
> cfg80211: Calling CRDA for country: JP
> .....
> ath5k 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> ath5k 0000:05:00.0: setting latency timer to 64
> ath5k 0000:05:00.0: registered as 'phy0'
> phy0: Selected rate control algorithm 'minstrel'
> ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
> .....
> wlan0: authenticate with AP 00:04:ed:42:60:67
> wlan0: authenticated
> wlan0: associate with AP 00:04:ed:42:60:67
> wlan0: RX AssocResp from 00:04:ed:42:60:67 (capab=3D0x431 status=3D0 id=3D)
> wlan0: associated
> ....."
> 
> lspci:
> "05:00.0 Ethernet controller: Atheros Communications Inc. AR242x 802.11abg 
> Wireless PCI Express Adapter (rev 01)
>           Subsystem: Device 1a3b:1026
>           Flags: bus master, fast devsel, latency 0, IRQ 16
>           Memory at feaf0000 (64-bit, non-prefetchable) [size=3D64K]
>           Capabilities: [40] Power Management version 2
>           Capabilities: [50] Message Signalled Interrupts: Mask- 64bit Queue=3D0/0 Enable-
>           Capabilities: [60] Express Legacy Endpoint, MSI 00
>           Capabilities: [90] MSI-X: Enable- Mask- TabSize=3D1
>           Capabilities: [100] Advanced Error Reporting <?>
>           Capabilities: [140] Virtual Channel <?>"
> 
> TIA,
> Irwan.
> 
> 
>       
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

