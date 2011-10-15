Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60205 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab1JOLpq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Oct 2011 07:45:46 -0400
Received: by wwe6 with SMTP id 6so98304wwe.1
        for <linux-wireless@vger.kernel.org>; Sat, 15 Oct 2011 04:45:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E9970A6.10305@openwrt.org>
References: <CAN=pzd+TcY+n90RBMU+Cpp0Bt9d_eAGgY4yffO+PSStWSzbf-Q@mail.gmail.com>
	<4E9970A6.10305@openwrt.org>
Date: Sat, 15 Oct 2011 15:45:45 +0400
Message-ID: <CAN=pzd+ou1DXL_d_W0dvTcYrNMfH9NjSoFUa=07fE4BYJ+N7bQ@mail.gmail.com> (sfid-20111015_134551_354044_417F1305)
Subject: Re: Ath9k, single antenna on ar9280
From: Stanislav Demakov <s.demakov@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok, just have tried:

ifconfig wlan0 down

and then tested it:

iw phy phy0 set antenna all all

but it's only showing iw help as before.
I'm using the latest compiled compat-wireless.

2011/10/15 Felix Fietkau <nbd@openwrt.org>:
> On 2011-10-14 5:46 PM, Stanislav Demakov wrote:
>>
>> I've noticed that set_antenna and get_antenna functionality was added
>> to the ath9k driver. But iw phy set antenna command still isn't
>> working.
>
> Did you try bringing down all active wlanX interfaces belonging to that phy
> before running that command?
>
> - Felix
>
