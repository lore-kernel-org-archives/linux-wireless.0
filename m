Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63404 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab1JOMNV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Oct 2011 08:13:21 -0400
Received: by wyg36 with SMTP id 36so858503wyg.19
        for <linux-wireless@vger.kernel.org>; Sat, 15 Oct 2011 05:13:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E997413.8010008@openwrt.org>
References: <CAN=pzd+TcY+n90RBMU+Cpp0Bt9d_eAGgY4yffO+PSStWSzbf-Q@mail.gmail.com>
	<4E9970A6.10305@openwrt.org>
	<CAN=pzd+ou1DXL_d_W0dvTcYrNMfH9NjSoFUa=07fE4BYJ+N7bQ@mail.gmail.com>
	<4E997413.8010008@openwrt.org>
Date: Sat, 15 Oct 2011 16:13:19 +0400
Message-ID: <CAN=pzd+R42SArWR+gEgqvJ7h1_6ZnB61xyKzOo8FqNxkRhxqrQ@mail.gmail.com> (sfid-20111015_141329_571062_9CD34535)
Subject: Re: Ath9k, single antenna on ar9280
From: Stanislav Demakov <s.demakov@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok, I've compiled and installed iw from git. Now I have this (wlan0 is down):

sudo iw phy phy0 set antenna 1 1

command failed: Operation not supported (-95)


2011/10/15 Felix Fietkau <nbd@openwrt.org>:
> On 2011-10-15 1:45 PM, Stanislav Demakov wrote:
>>
>> Ok, just have tried:
>>
>> ifconfig wlan0 down
>>
>> and then tested it:
>>
>> iw phy phy0 set antenna all all
>>
>> but it's only showing iw help as before.
>> I'm using the latest compiled compat-wireless.
>
> Try using "1 1" instead of "all all".
> Are you using the latest iw version?
>
> - Felix
>
