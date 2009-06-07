Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:58392 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbZFGM7V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 08:59:21 -0400
Received: by bwz9 with SMTP id 9so2481766bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2009 05:59:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A2BB2BB.7000605@cern.ch>
References: <4A2BA2E0.7020709@cern.ch> <4A2BB2BB.7000605@cern.ch>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 7 Jun 2009 14:59:01 +0200
Message-ID: <69e28c910906070559n6b9db923ucd73ccfc78cb382f@mail.gmail.com>
Subject: Re: Which firmware for Belkin F5D7050 (ISL3880 + NET2280)
To: Wojciech Zabolotny CERN <wojciech.zabolotny@cern.ch>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 7, 2009 at 2:29 PM, Wojciech Zabolotny
CERN<wojciech.zabolotny@cern.ch> wrote:
> Hi,
>
> I've managed to run my NIC with the older firmware:
> http://daemonizer.de/prism54/prism54-fw/fw-usb/2.13.1.0.lm86.arm
>
> Now I get the following output in dmesg:
>
> cfg80211: Using static regulatory domain info
> cfg80211: Regulatory domain: US
>    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>    (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
>    (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
>    (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
>    (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
>    (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
>    (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
> cfg80211: Calling CRDA for country: US
> usb 1-4: firmware: requesting isl3886usb
> phy0: p54 detected a LM86 firmware
> p54: rx_mtu reduced from 3240 to 2392
> phy0: FW rev 2.13.1.0 - Softmac protocol 5.5
> phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
> phy0: hwaddr 00:30:43:11:33:39, MAC:isl3886 RF:Frisbee
> wmaster0 (p54usb): not using net_device_ops yet
> phy0: Selected rate control algorithm 'minstrel'
> wlan0 (p54usb): not using net_device_ops yet
> usbcore: registered new interface driver p54usb
>
>
> Then everything works correctly.
> So it seems, that the new firmware is just incompatible with this card :-(.

What about an LM87 firmware? It should be supported now...

> --
> BR, WZab
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
