Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f173.google.com ([74.125.82.173]:43866 "EHLO
        mail-ot0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751123AbdLLCVs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 21:21:48 -0500
Received: by mail-ot0-f173.google.com with SMTP id y10so16558442otg.10
        for <linux-wireless@vger.kernel.org>; Mon, 11 Dec 2017 18:21:48 -0800 (PST)
Subject: Re: rtl8723bu support on Complex 11t
To: James Hemsing <jhemsing@gmail.com>, linux-wireless@vger.kernel.org
References: <CADBo=zzcMzFCOdbbskpPStJZdt4s7wdavPefqo9iHi_zVSzJTg@mail.gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <07a73398-fbc8-7c84-9512-edff9cbc5e89@lwfinger.net> (sfid-20171212_032151_681371_9BDC8AAF)
Date: Mon, 11 Dec 2017 20:21:45 -0600
MIME-Version: 1.0
In-Reply-To: <CADBo=zzcMzFCOdbbskpPStJZdt4s7wdavPefqo9iHi_zVSzJTg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/11/2017 06:59 PM, James Hemsing wrote:
> Hello,
> 
> I have a Complex 11t tablet with this wireless card on USB. The kernel
> driver supports it, but even at its best, it doesn't work at full
> speed and frequently loses connections, whereas Windows 10 doesn't
> have any problems. I'd be happy to test and debug code, and provide
> whatever help I can to improve the driver for this device. Here is
> some system information. The kernel I'm currently using is version
> 4.13.0 on Ubuntu 17.10.
> 
> Thanks,
> James
> 
> [    4.031513] Bluetooth: hci0: rtl: examining hci_ver=06 hci_rev=000b
> lmp_ver=06 lmp_subver=8723
> [    4.031515] Bluetooth: hci0: rtl: loading rtl_bt/rtl8723b_config.bin
> [    4.032132] bluetooth hci0: Direct firmware load for
> rtl_bt/rtl8723b_config.bin failed with error -2
> [    4.032136] Bluetooth: hci0: rtl: loading rtl_bt/rtl8723b_fw.bin
> [    4.160515] usb 1-6: rtl8723bu_parse_efuse: dumping efuse (0x200 bytes):
> [    4.160667] usb 1-6: RTL8723BU rev E (SMIC) 1T1R, TX queues 3,
> WiFi=1, BT=1, GPS=0, HI PA=0
> [    4.160670] usb 1-6: RTL8723BU MAC: 7c:c7:09:69:b6:3a
> [    4.160674] usb 1-6: rtl8xxxu: Loading firmware rtlwifi/rtl8723bu_nic.bin
> [    5.038493] 8723bu: loading out-of-tree module taints kernel.
> [    5.039092] 8723bu: module verification failed: signature and/or
> required key missing - tainting kernel

Why are you loading BOTH rtl8xxxu and 8723bu? The conflict between them will 
cause all kinds of problems.

Larry
