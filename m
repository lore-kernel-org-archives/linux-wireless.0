Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm26-vm5.bullet.mail.ir2.yahoo.com ([212.82.97.47]:32414 "EHLO
	nm26-vm5.bullet.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752682Ab3KDJ20 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Nov 2013 04:28:26 -0500
References: <1382537927.62604.YahooMailNeo@web171801.mail.ir2.yahoo.com>	<1382538469.7892.YahooMailNeo@web171805.mail.ir2.yahoo.com>	<20131024112206.GB1677@redhat.com>	<1382614336.89589.YahooMailNeo@web171804.mail.ir2.yahoo.com>	<20131024113748.GD1677@redhat.com>	<1383227814.41997.YahooMailNeo@web171801.mail.ir2.yahoo.com>	<527264F6.2030001@hauke-m.de>	<1383233873.6949.YahooMailNeo@web171806.mail.ir2.yahoo.com> <CAL1gcdNyW-Z7YkQYsbpbxr+zdoXnoE9KcZi9E1q0SoVOV6LQ_A@mail.gmail.com>
Message-ID: <1383557304.87663.YahooMailNeo@web171803.mail.ir2.yahoo.com> (sfid-20131104_102830_800645_416B8DBB)
Date: Mon, 4 Nov 2013 09:28:24 +0000 (GMT)
From: Gianfranco Costamagna <costamagnagianfranco@yahoo.it>
Reply-To: Gianfranco Costamagna <costamagnagianfranco@yahoo.it>
Subject: Re: Edimax EW-7733UnD
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <CAL1gcdNyW-Z7YkQYsbpbxr+zdoXnoE9KcZi9E1q0SoVOV6LQ_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> Il Giovedì 31 Ottobre 2013 16:49, Gertjan van Wingerde <gwingerde@gmail.com> ha scritto:

> > On Thu, Oct 31, 2013 at 4:37 PM, Gianfranco Costamagna
> 
> <costamagnagianfranco@yahoo.it> wrote:
>> 
>>> Aren't you trying to get a RT3573 card to work? You should activate
>>> CONFIG_RT2800USB_RT3573.
>> 
>> 
>>  I'm rebuilding the kernel with this module, but I don't think this 
> is my chip
>> 
> http://www.edimax.com/au/produce_detail.php?pd_id=399&pl1_id=1&pl2_id=44
>> 
>>  is it?
>> 
> 
> It should be, as it is the only Ralink chipset that supports 3x3
> operation (i.e. 450 Mbps).
> Also, the USB id of the device is listed in the driver under that
> configuration option, so I'm pretty sure you
> have to enable that configuration option ;-)
> 

Yep indeed, after enabling it everything was fine :)

So maybe ubuntu kernel developers disable the module by default? In this case I'll ask them to enable it...

Last question, is it normal than disabling the wifi switch (hardware) on my laptop also the usb key gets disabled?


I think I also had to modprobe rt2800usb for enabling it... don't know

Linux gianfranco-Latitude-E5520 3.12.0-rc5-wl #3 SMP Thu Oct 31 16:17:50 CET 2013 x86_64 x86_64 x86_64 GNU/Linux


[  741.973598] usb 2-1.4: new high-speed USB device number 14 using ehci-pci
[  742.082098] usb 2-1.4: New USB device found, idVendor=7392, idProduct=7733
[  742.082103] usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  742.082105] usb 2-1.4: Product: 802.11 n WLAN
[  742.082107] usb 2-1.4: Manufacturer: Ralink
[  742.082109] usb 2-1.4: SerialNumber: 1.0
[  742.157836] usb 2-1.4: reset high-speed USB device number 14 using ehci-pci
[  742.259161] ieee80211 phy6: rt2x00_set_rt: Info - RT chipset 3593, rev 0402 detected
[  742.287567] ieee80211 phy6: rt2x00_set_rf: Info - RF chipset 000d detected
[  742.287949] ieee80211 phy6: Selected rate control algorithm 'minstrel_ht'
[  742.305198] ieee80211 phy6: rt2x00lib_request_firmware: Info - Loading firmware file 'rt2870.bin'
[  742.305226] ieee80211 phy6: rt2x00lib_request_firmware: Info - Firmware detected - version: 0.29
[  742.558830] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  749.516755] wlan1: authenticate with 90:f6:52:3b:2c:88
[  749.601351] wlan1: send auth to 90:f6:52:3b:2c:88 (try 1/3)
[  749.706159] wlan1: send auth to 90:f6:52:3b:2c:88 (try 2/3)
[  749.709059] wlan1: authenticated
[  749.710172] wlan1: associate with 90:f6:52:3b:2c:88 (try 1/3)
[  749.714112] wlan1: RX AssocResp from 90:f6:52:3b:2c:88 (capab=0x431 status=0 aid=4)
[  749.721140] wlan1: associated
[  749.721172] IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[  749.721258] cfg80211: Calling CRDA for country: IT
[  749.724127] cfg80211: Regulatory domain changed to country: IT
[  749.724131] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  749.724132] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  749.724134] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  749.724135] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  749.724136] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[  749.724137] cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz), (N/A, 4000 mBm)


Thanks for your help!
I really appreciated it ;)

Cheers!

Gianfranco
> -- 
> ---
> Gertjan
> 
