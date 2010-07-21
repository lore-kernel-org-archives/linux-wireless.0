Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62331 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab0GURBo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 13:01:44 -0400
Received: by bwz1 with SMTP id 1so349842bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jul 2010 10:01:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C45ED36.2090604@deltatee.com>
References: <4C37BCA0.5090607@deltatee.com>
	<AC090B9732AB2B4DB7FF476E907FE660010685F34E@dnce02.ent.ti.com>
	<AANLkTilHNKeRZX5CMplyriTo2hTPBrz_z1_Zpwoy3SZx@mail.gmail.com>
	<AC090B9732AB2B4DB7FF476E907FE66001069662F2@dnce02.ent.ti.com>
	<AC090B9732AB2B4DB7FF476E907FE6600106966BA5@dnce02.ent.ti.com>
	<4C45ED36.2090604@deltatee.com>
Date: Wed, 21 Jul 2010 19:01:42 +0200
Message-ID: <AANLkTinjvF9UeV7d2aBUy6HfexuAeL_cdsVPGVxSRVMp@mail.gmail.com>
Subject: Re: wl1271 firmware
From: Pazzo Da Legare <pazzodalegare@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: "Levi, Shahar" <shahar_levi@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	Logan Gunthorpe <logang@deltatee.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear All,
Dear Shahar,

I tried your files but I had errors from the driver.

# ifconfig wlan0 up

[  194.470000] wl1271_sdio mmc0:0001:2: firmware: requesting wl1271-fw.bin
[  194.620000] wl1271_sdio mmc0:0001:2: firmware: requesting wl1271-nvs.bin
[  195.080000] ADDRCONF(NETDEV_UP): wlan0: link is not ready
root@hawkboard:~# [  195.590000] wl1271: ERROR ELP wakeup timeout!

I tried to scan but it doesn't work. Note that I'm using a driver
built from compact-wireless-2010-06-20 and I'm going to try to update.

Thank you for your help again,

pz


2010/7/20 Logan Gunthorpe <logang@deltatee.com>:
> Hi Sharar,
>
> Thanks a lot. I'm pleased to report that our module appears to be working
> with the firmware and NVS files you supplied.
>
> Logan
>
> Levi, Shahar wrote:
>>>
>>> -----Original Message-----
>>> From: Levi, Shahar
>>> Sent: Saturday, July 17, 2010 3:20 PM
>>> To: Pazzo Da Legare
>>> Cc: linux-wireless@vger.kernel.org; Logan Gunthorpe; Luciano Coelho
>>> Subject: RE: wl1271 firmware
>>> Hi Pazzo,
>>> I am still pushing the legal stuff to make it happened. I hope to close
>>> that in a few days.
>>> Regards,
>>> Shahar
>>
>> Hi Pazzo and Logan,
>> Until the file will publish in TI web I am enclosing the file for you in
>> the mail.
>> I will publish link to the community as soon it will be in the TI web.
>>
>> Regards,
>> Shahar
>>
>
