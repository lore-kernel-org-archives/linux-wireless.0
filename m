Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2-g19.free.fr ([212.27.42.28]:55797 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756789AbYFVV6a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2008 17:58:30 -0400
Message-ID: <485ECB04.6010108@free.fr> (sfid-20080622_235946_378682_90D09112)
Date: Sun, 22 Jun 2008 23:58:28 +0200
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Stefanik_G=E1bor?= <netrolller.3d@gmail.com>
CC: linux-wireless@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: zd1211 stability issue on 2.6.25
References: <485EAC63.1070709@free.fr> <69e28c910806221252u5a0fc574ucadc9df3d4147f30@mail.gmail.com>
In-Reply-To: <69e28c910806221252u5a0fc574ucadc9df3d4147f30@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefanik G=E1bor wrote:
> On Sun, Jun 22, 2008 at 9:47 PM, matthieu castet
> <castet.matthieu@free.fr> wrote:
>> Hi,
>>
>> I am using a zd1211 dongle [1] on 2.6.25 in wpa mode. Sometimes I go=
t
>> disconnection [2]. But after that scanning seems to doesn't work any=
more
>> [3].
>> This cause wpa_supplicant to do an endless lop try to find the AP in=
 the
>> scan result and there no reconnection.
>> Only a ifconfig wlan0 down, ifconfig wlan0 up make work again scanni=
ng.
>>
>> This make the dongle not usable.
>>
>> Matthieu
>>
>>
>>
>> [1]
>> phy0: Selected rate control algorithm 'pid'
>> firmware version 4725
>> zd1211rw 1-5:1.0: zd1211b chip 079b:0062 v4810 high 00-60-b3 AL2230_=
RF
>> pa0 g----
>>
>> [2]
>>  wlan0: No ProbeResp from current AP 00:07:cb:50:0d:e6 - assume out =
of
>> range
>>
>> [3]
>> $sudo iwlist wlan0 scan
>> wlan0     Interface doesn't support scanning : Network is down
Opps I copy here the wrong data.
I don't remember the result exactly, but that was something telling it=20
didn't find anything.

I got this trace after doing a ifconfig down


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
