Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:34709 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764322AbdKRHuT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Nov 2017 02:50:19 -0500
Received: by mail-wm0-f52.google.com with SMTP id y82so564696wmg.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Nov 2017 23:50:19 -0800 (PST)
Subject: Re: rtl8723be on Fedora27
To: rosenp@gmail.com, linux-wireless@vger.kernel.org
References: <f5876284-360c-e6bf-01c8-ed95c4298647@gmail.com>
 <1510981609.5145.0.camel@gmail.com>
From: =?UTF-8?Q?R=c3=a1kosi_Gergely?= <rakosi.gergely@gmail.com>
Message-ID: <21a2cc76-ed4e-22a2-3eb2-1f4b8df348fd@gmail.com> (sfid-20171118_085028_710923_F9F0F6D5)
Date: Sat, 18 Nov 2017 08:50:15 +0100
MIME-Version: 1.0
In-Reply-To: <1510981609.5145.0.camel@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I put in to blacklist the module rtlwifi and rtl8723be, and now I get:
- kde's networkmanager did not recognize wireless devices
- in the messages log there are the following :
"registered new interface driver rtl8xxxu
Bluetooth: hci0: rtl : Direct firmware load for
rtl_bt/rtl8723b_config.bin failed with error -2
- ifconfig give no wireless devices (wlp2s0 or wlan0)

If I blacklist only rtlwifi then load the rtl8723be module like normal.

Thanks,
Geri

2017-11-18 06:06 keltezéssel, rosenp@gmail.com írta:
> On Fri, 2017-11-17 at 09:16 +0100, Rákosi Gergely wrote:
>> Hello,
>>
>> I'm trying to use rtl8723be wifi on Fedora27 but I still get
>> continuosly
>> disconnection. The error in the dmesg is "Init MAC failed"
>> I tried with the following module options too : "fwlps=0 swlps=0" and
>> the variant of "ant_sel=1 or 2 or 0"
>> I downloaded the git files from your repo, and do the usual make,make
>> install, and modprobe stuffs, and then restart the notebook, but I
>> get
>> the same result.
>>
> Could try blacklisting rtlwifi. That way it uses rtl8xxxu.
>> Thanks your help,
>> Regards,
>> Gergely
