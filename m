Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42106 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab0GUR1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 13:27:07 -0400
Received: by fxm14 with SMTP id 14so3748984fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jul 2010 10:27:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinjvF9UeV7d2aBUy6HfexuAeL_cdsVPGVxSRVMp@mail.gmail.com>
References: <4C37BCA0.5090607@deltatee.com>
	<AC090B9732AB2B4DB7FF476E907FE660010685F34E@dnce02.ent.ti.com>
	<AANLkTilHNKeRZX5CMplyriTo2hTPBrz_z1_Zpwoy3SZx@mail.gmail.com>
	<AC090B9732AB2B4DB7FF476E907FE66001069662F2@dnce02.ent.ti.com>
	<AC090B9732AB2B4DB7FF476E907FE6600106966BA5@dnce02.ent.ti.com>
	<4C45ED36.2090604@deltatee.com>
	<AANLkTinjvF9UeV7d2aBUy6HfexuAeL_cdsVPGVxSRVMp@mail.gmail.com>
Date: Wed, 21 Jul 2010 19:27:04 +0200
Message-ID: <AANLkTinnYeJPV-xxg7DdPXnWW_kD7X1TVcd9HrhupJWS@mail.gmail.com>
Subject: Re: wl1271 firmware
From: Pazzo Da Legare <pazzodalegare@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: "Levi, Shahar" <shahar_levi@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	Logan Gunthorpe <logang@deltatee.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear All again,

I've just test with compact-wireless-2010-07-20 but I've the same problem:

root@hawkboard:~# ifconfig wlan0 192.168.0.1 up
[   68.920000] wl1271_sdio mmc0:0001:2: firmware: requesting wl1271-fw.bin
[   69.100000] wl1271_sdio mmc0:0001:2: firmware: requesting wl1271-nvs.bin
[   69.510000] ADDRCONF(NETDEV_UP): wlan0: link is not ready
root@hawkboard:~# [   70.020000] wl1271: ERROR ELP wakeup timeout!
[   70.520000] wl1271: ERROR ELP wakeup timeout!


looking at dmesg:

[  68.920000] wl1271_sdio mmc0:0001:2: firmware: requesting wl1271-fw.bin
[   69.100000] wl1271_sdio mmc0:0001:2: firmware: requesting wl1271-nvs.bin
[   69.500000] wl1271: firmware booted (Rev 6.1.0.0.310)
[   69.510000] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   70.020000] wl1271: ERROR ELP wakeup timeout!
[   70.520000] wl1271: ERROR ELP wakeup timeout!

[   68.920000] wl1271_sdio mmc0:0001:2: firmware: requesting wl1271-fw.bin
[   69.100000] wl1271_sdio mmc0:0001:2: firmware: requesting wl1271-nvs.bin
[   69.500000] wl1271: firmware booted (Rev 6.1.0.0.310)
[   70.020000] wl1271: ERROR ELP wakeup timeout!
[   70.520000] wl1271: ERROR ELP wakeup timeout!

Do you have any clue?

pz


2010/7/21 Pazzo Da Legare <pazzodalegare@gmail.com>:
> Dear All,
> Dear Shahar,
>
> I tried your files but I had errors from the driver.
>
> # ifconfig wlan0 up
>
> [  194.470000] wl1271_sdio mmc0:0001:2: firmware: requesting wl1271-fw.bin
> [  194.620000] wl1271_sdio mmc0:0001:2: firmware: requesting wl1271-nvs.bin
> [  195.080000] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> root@hawkboard:~# [  195.590000] wl1271: ERROR ELP wakeup timeout!
>
> I tried to scan but it doesn't work. Note that I'm using a driver
> built from compact-wireless-2010-06-20 and I'm going to try to update.
>
> Thank you for your help again,
>
> pz
>
>
> 2010/7/20 Logan Gunthorpe <logang@deltatee.com>:
>> Hi Sharar,
>>
>> Thanks a lot. I'm pleased to report that our module appears to be working
>> with the firmware and NVS files you supplied.
>>
>> Logan
>>
>> Levi, Shahar wrote:
>>>>
>>>> -----Original Message-----
>>>> From: Levi, Shahar
>>>> Sent: Saturday, July 17, 2010 3:20 PM
>>>> To: Pazzo Da Legare
>>>> Cc: linux-wireless@vger.kernel.org; Logan Gunthorpe; Luciano Coelho
>>>> Subject: RE: wl1271 firmware
>>>> Hi Pazzo,
>>>> I am still pushing the legal stuff to make it happened. I hope to close
>>>> that in a few days.
>>>> Regards,
>>>> Shahar
>>>
>>> Hi Pazzo and Logan,
>>> Until the file will publish in TI web I am enclosing the file for you in
>>> the mail.
>>> I will publish link to the community as soon it will be in the TI web.
>>>
>>> Regards,
>>> Shahar
>>>
>>
>
