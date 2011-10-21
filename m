Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55770 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab1JUH23 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 03:28:29 -0400
Received: by qyk27 with SMTP id 27so3569950qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2011 00:28:29 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <4EA0EE26.8010107@lwfinger.net>
References: <CAN4ACka-egrr=GnBomT0Yc_r_mzS-+v8OE=D0vBoH+jFQJwX8w@mail.gmail.com>
	<4EA0EE26.8010107@lwfinger.net>
Date: Fri, 21 Oct 2011 09:28:28 +0200
Message-ID: <CA+icZUVGi9t6Prawqz4jDqChFR+w8X9xmc_wRgPmHG3BwUVEpw@mail.gmail.com> (sfid-20111021_092832_671031_EA1E4FAB)
Subject: Re: rtl8192cu - fails to maintain connection to some Access Points
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Alan Pater <alan.pater@gmail.com>, linux-wireless@vger.kernel.org,
	George0505 <george0505@realtek.com>,
	georgia <georgia@realtek.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 21, 2011 at 5:59 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 10/20/2011 06:02 PM, Alan Pater wrote:
>>
>> Hi folks
>>
>> Several people over on Ubuntu Launchpad are reporting that this USB WiFi
>> adaptor has issues connecting to certain access points. In my case, I
>> cannot
>> connect to a Meraki mesh network, but have no trouble when using my
>> Android
>> phone as a WiFi Access Point.
>>
>> The launchpad bugs are:
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/852190
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/869530
>>
>> https://bugs.launchpad.net/ubuntu/+source/linux-backports-modules-3.0.0/+bug/862684
>>
>> ~$ uname -a
>> Linux crow 2.6.38-11-generic #50-Ubuntu SMP Mon Sep 12 21:18:14 UTC 2011
>> i686 i686 i386 GNU/Linux
>> ~$ lsusb
>> Bus 001 Device 004: ID 0bda:8176 Realtek Semiconductor Corp.
>>
>> Note that I have tried newer kernels, including 3.1.0 without it making a
>> difference.
>>
>> Is there some other steps we could be taking to figure out what is going
>> on
>> here?
>
> You need to run wireshark on a different computer and capture the attempt to
> connect. The device works with my 3 APs, but none are Meraki.
>

Asking as a non-native speaker/writer: What do you mean by "Meraki"?

- Sedat -

[1] http://meraki.com/products/wireless/wifi-stumbler

> Larry
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
