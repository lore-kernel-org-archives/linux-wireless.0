Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:44467 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753706AbdKAAvd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Oct 2017 20:51:33 -0400
Received: by mail-wr0-f194.google.com with SMTP id z55so640015wrz.1
        for <linux-wireless@vger.kernel.org>; Tue, 31 Oct 2017 17:51:32 -0700 (PDT)
From: nirinA raseliarison <nirina.raseliarison@gmail.com>
Subject: Re: rtlwifi oops
To: Barry Day <briselec@gmail.com>, James Cameron <quozl@laptop.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org
References: <c13aa975-6339-2f5a-20bb-0a82656a2271@gmail.com>
 <fcf4b761-d7bd-7956-fa98-07fd8b2f8c3b@lwfinger.net>
 <b86480bd-49b9-f7ac-5dc5-6f6f83942727@gmail.com>
 <d65baa01-c842-0d14-5760-bbc1c754b1e6@lwfinger.net>
 <d9e6052f-cc92-813b-6cd6-9907f5bd82be@gmail.com>
 <a1ca0a52-c033-205a-8b3e-e6879016728c@gmail.com>
 <20171027045716.GH9888@us.netrek.org>
 <7532bb89-9f58-f2e2-e9c3-baa4be24da81@gmail.com>
 <20171027225701.GB8920@us.netrek.org>
 <bd5a4917-96e7-c9ef-909a-e8e4f34b0ef1@gmail.com>
 <20171031031110.GA4627@darkstar.home.org>
Message-ID: <bfa02605-dc37-c425-ff1e-0bd43d8c9754@gmail.com> (sfid-20171101_015327_648454_7A8EDEAE)
Date: Wed, 1 Nov 2017 03:51:14 +0300
MIME-Version: 1.0
In-Reply-To: <20171031031110.GA4627@darkstar.home.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/31/2017 06:11 AM, Barry Day wrote:
> On Sun, Oct 29, 2017 at 01:08:24AM +0300, nirinA raseliarison wrote:
>> [  145.966016] usb 2-1.4: new high-speed USB device number 4 using ehci-pci
>> [  146.045808] usb 2-1.4: New USB device found, idVendor=0bda,
>> idProduct=8178
>> [  146.045811] usb 2-1.4: New USB device strings: Mfr=1, Product=2,
>> SerialNumber=3
>> [  146.045812] usb 2-1.4: Product: 802.11n WLAN Adapter
>> [  146.045813] usb 2-1.4: Manufacturer: Realtek
>> [  146.045814] usb 2-1.4: SerialNumber: 00e04c000001
>> [  146.202043] rtl8192cu: Chip version 0x11
>> [  146.278549] rtl8192cu: Board Type 0
>> [  146.278790] rtl_usb: rx_max_size 15360, rx_urb_num 8, in_ep 1
>> [  146.278823] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
>> [  146.278938] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
>> [  146.279113] usbcore: registered new interface driver rtl8192cu
>> [  146.281706] usbcore: registered new interface driver rtl8xxxu
>> --
>> nirinA
>
> It appears that both rtl8192cu and rtl8xxxu are being loaded for the
> one device.
>
> Try blacklisting one of them.

both seem to work fine; i'll use rtl8192cu and blacklist rtl8xxxu.

thanks,

> Barry
>
--
nirinA
