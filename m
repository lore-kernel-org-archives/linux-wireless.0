Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail01.spothost.nl ([77.74.49.150]:35672 "EHLO
	webmail01.spothost.nl" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751875Ab1HIPMv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 11:12:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 09 Aug 2011 15:12:50 +0000
From: kc@cobradevil.org
To: <kc@cobradevil.org>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: rtl8192cu sometimes it can authenticate to ap
In-Reply-To: <34676454425401d650be733a43191a53@cobradevil.org>
References: <b3059ba2eac66b7ef0ec17c8fe81a1e6@cobradevil.org>
 <34676454425401d650be733a43191a53@cobradevil.org>
Message-ID: <532595cb4d5ef910de54a4736ba76185@cobradevil.org> (sfid-20110809_171258_642036_3EE90F58)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

not sure what is happening but so far i have the following results:
i downloaded the latest bleeding edge wireless from 
http://wireless.kernel.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2
I installed kernel headers and build-essentials end run:
./scripts/driver-select rtlwifi
make && make install

i downloaded the firmware from 
http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git

Running on Ubuntu maverick kernel 2.6.35-30 update 56 i get sometimes 
an authenticated message when running wpa_supplicant -Dnl80211 -c 
/etc/wpa_supplicant.conf -i wlan0 but most times it will timeout
Running on Ubuntu natty kernel 2.6.38-10 update 46 i always get the 
authenticated message when running wpa_supplicant -Dnl80211 -c 
/etc/wpa_supplicant.conf -i wlan0

only when using dhcp request on two accespoint i get different results 
on the natty driver but that has todo with: 
https://bugzilla.kernel.org/show_bug.cgi?id=38012 when applied i can 
connect two both accespoints.

Any ideas why it does not work on the maverick kernel?

Also when stopping the wpa_supplicant with ctrl+c and restart i first 
have to replug the device before it tries todo anything with the card.

With kind regards

William


On Tue, 09 Aug 2011 11:07:56 +0000, kc@cobradevil.org wrote:

> Hi all,
>
> Have installed natty and also installed the snapshot.
>
> After compile and installed the rtlwifi driver the wpa_supplicant 
> works
> like a charm every time with all three sticks.
> So i think it is something in the compat layer or userland utilities?
>
> Anyone an idea?
> I would like this to work with the maverick kernel 2.6.35 because we
> cannot upgrade right now.
>
> With kind regards
>
> William
>
> On Tue, 09 Aug 2011 09:16:12 +0000, kc@cobradevil.org [2]wrote:
>
>> Hello all, i have three usb sticks with the the id: 0bda:8176 I am
>> running ubuntu maverick with the compat tree from 2011-08-08
>> (downloaded this morning) and i also tried several others (dates 
>> from
>> 15 juli 2011). The main problem is that sometimes i get a connection
>> and it works like a charm and then all of the sudden i don't get any
>> connection at all and running wpa_supplicant says time out. i really
>> have no idea whats wrong so if someone could help me out. is there a
>> way to get debugging from the rtlwifi drivers? i got the firmware 
>> from:
>> http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git 
>> [1]
>> [1] With kind regards William
>
> Links:
> ------
> [1] 
> http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git
> [3]


Links:
------
[1] http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git
[2] mailto:kc@cobradevil.org
[3] http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git
