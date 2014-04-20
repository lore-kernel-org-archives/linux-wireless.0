Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:58503 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaDTIQ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2014 04:16:56 -0400
Received: by mail-qg0-f54.google.com with SMTP id z60so2987602qgd.41
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2014 01:16:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6b9c9c14-ca58-4b9a-969f-024b57a43dde@googlegroups.com>
References: <6b9c9c14-ca58-4b9a-969f-024b57a43dde@googlegroups.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sun, 20 Apr 2014 18:16:34 +1000
Message-ID: <CAGRGNgXk+R=Y+uTiiVXS0tyZ0Ho=3=bCK=qwRC+_MWLRhuOXww@mail.gmail.com> (sfid-20140420_101744_512762_02AE7DC4)
Subject: Re: [linux-sunxi] Usb WifiProblem
To: linux-sunxi@googlegroups.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mahdi,

This looks like a wireless driver issue. I've CC'd linux-wireless and
they might be able to help you.

On Sun, Apr 20, 2014 at 5:14 PM, mahdi taheri <stu.mahdi@gmail.com> wrote:
> kernel 3.4.79
>
> I am using usb wifi (my usb wifi is tp-link tl-wn727n , chipset is  rt5370n
> ) for cubieboard2. at startup  I have no problem with wifi module but if I
> disconnect wifi usb from port i shows an error :
>
> ehci_irq: port change detect
> <6>usb 4-1: USB disconnect, device number 3
> <3>phy1 -> rt2800_wait_wpdma_ready: Error - WPDMA TX/RX busy, aborting.
> [  205.422151] phy1 -> rt2800_wait_wpdma_ready: Error - WPDMA TX/RX busy,
> aborting.
>
>
> and after that it dosent work untill next restart:
>
> usb 4-1: new high-speed USB device number 3 using sw-ehci
> <6>usb 4-1: reset high-speed USB device number 3 using sw-ehci
> <7>ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
> <7>Registered led device: rt2800usb-phy1::radio
> <7>Registered led device: rt2800usb-phy1::assoc
> <7>Registered led device: rt2800usb-phy1::quality
> <30>udevd[240]: renamed network interface wlan0 to wlan1
> <6>ADDRCONF(NETDEV_UP): wlan1: link is not ready
> <6>ADDRCONF(NETDEV_UP): wlan1: link is not ready
>
>
> ifup wlan1
> <6>ADDRCONF(NETDEV_UP): wlan1: link is not ready
>
>
> --
> You received this message because you are subscribed to the Google Groups
> "linux-sunxi" group.
> To unsubscribe from this group and stop receiving emails from it, send an
> email to linux-sunxi+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/d/optout.



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
