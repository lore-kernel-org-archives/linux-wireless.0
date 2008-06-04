Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:22874 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbYFDLZI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 07:25:08 -0400
Received: by fg-out-1718.google.com with SMTP id 19so26571fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2008 04:25:06 -0700 (PDT)
Date: Wed, 04 Jun 2008 13:25:00 +0200
To: "Emmanuel Grumbach" <egrumbach@gmail.com>
Subject: Re: iwlwifi: Bug - can't connect to WPA PSK access point any more
From: Barteq <barteqpl@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=utf-8;
	format=flowed	delsp=yes
MIME-Version: 1.0
References: <op.ub3jirfui79708@thinkpad> <8704f27d0806020801g1785d067j9c28832a7e5c39e3@mail.gmail.com> <op.ub4p98zui79708@thinkpad> <8704f27d0806030409n7e5ef084x5801871c36b6f846@mail.gmail.com> <op.ub6muuyji79708@thinkpad> <8704f27d0806040040n5aa05b87j10142e31ed1a2b44@mail.gmail.com>
Message-ID: <op.ub71zybqi79708@thinkpad> (sfid-20080604_132512_740705_1F1F04B8)
In-Reply-To: <8704f27d0806040040n5aa05b87j10142e31ed1a2b44@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dnia 04-06-2008 o 09:40:10 Emmanuel Grumbach <egrumbach@gmail.com> =20
napisa=C5=82(a):

> black magic here... are you sure there is no other services in the
> area ? NM avahi and friends ?
>

Nm works in background with wifi turned off.
wlan0 is manually turned on again (ifconfig wlan0 up) and then =20
wpa_supplicant run.

There are no other supplicants.

Avahi? avahi only works while using ifup (debian/ubuntu specific) or NM=
=2E
Wpa_supplicant run by hand doesn't interfere with this service.. If not=
 - =20
please tell me how?

It's quite black magic for me too.. Im lost from about two months of =20
fighitng.. First wifi was extremly unstable and associated after 20 =20
minutes,
now it sometimes works after 30 min, but just after executing dhclient =
=20
connection drops with message about (i don't remeber well and no logs h=
ere)
'dropping packet, tkip counter didn't increase' or something like that.

This list is the last place where I can find any help. Trying to solve =
my =20
problems myself, but it took me too long without any positive results.

Regards,
Bartek
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
