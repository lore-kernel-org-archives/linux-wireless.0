Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tor.lindesign.se ([194.17.154.111]:48988 "EHLO tor.lindesign.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbYDEMBR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Apr 2008 08:01:17 -0400
Message-ID: <47F76A0A.3080806@tor.lindesign.se> (sfid-20080405_130120_224012_999BAF60)
Date: Sat, 05 Apr 2008 14:01:14 +0200
From: Bachman Kharazmi <bachman@tor.lindesign.se>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: compat-wireless iwl4965 on hp/compaq 2510p
References: <47F75EB4.9090703@tor.lindesign.se>	 (sfid-20080405_124018_600873_72164D53) <1207396223.3860.9.camel@johannes.berg>	 <47F76814.7010405@tor.lindesign.se> <1207396488.3860.12.camel@johannes.berg>
In-Reply-To: <1207396488.3860.12.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

lapp:/tmp# ip link set wlan0 up
SIOCSIFFLAGS: No such device
lapp:/tmp# iwconfig
lo        no wireless extensions.

eth1      no wireless extensions.

wmaster0  no wireless extensions.

wlan0     IEEE 802.11  ESSID:"planet_mars"
           Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated
           Tx-Power=0 dBm
           Retry min limit:7   RTS thr:off   Fragment thr=2352 B
           Encryption key:B200-A927-32DA-86E9-0DEF-EFF3-FB
           Link Quality:0  Signal level:0  Noise level:0
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0


note that dmesg sais
iwl4965: Detected Intel Wireless WiFi Link 4965AGN
iwl4965: Tunable channels: 13 802.11bg, 19 802.11a channels
phy1: Selected rate control algorithm 'iwl-4965-rs'
ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
iwl4965: Radio disabled by HW RF Kill switch

/Bachman

Johannes Berg wrote:
> On Sat, 2008-04-05 at 13:52 +0200, Bachman Kharazmi wrote:
>> Sure..
>> lapp:/tmp# iwconfig wlan0 essid planet_mars key B200A92732DA86E90DEFEFF3FB
> 
>> wlan0     IEEE 802.11  ESSID:"planet_mars"
>>            Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated
> 
>> receive_packet failed on wlan0: Network is down
> 
> Try turning on the interface first... 'ip link set wlan0 up' might help
> 
> johannes
