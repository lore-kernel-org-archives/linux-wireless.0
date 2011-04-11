Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46387 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab1DKNBL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 09:01:11 -0400
Received: by gyd10 with SMTP id 10so2134246gyd.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2011 06:01:10 -0700 (PDT)
Message-ID: <4DA2FB92.9070500@lwfinger.net>
Date: Mon, 11 Apr 2011 08:01:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: linux-wireless@vger.kernel.org,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	users@rt2x00.serialmonkey.com
Subject: Re: Firmware for rt2800pci and rt2800usb
References: <4DA2042A.3010301@gmail.com>	<1302469406.5282.341.camel@localhost>	<4DA22545.6050209@gmail.com>	<4DA2312B.8080303@lwfinger.net>	<4DA23594.8090002@gmail.com>	<4DA2702B.2080305@lwfinger.net> <BANLkTimdBz9iSvjfkmbRS7FfgBT-Bzdk7Q@mail.gmail.com>
In-Reply-To: <BANLkTimdBz9iSvjfkmbRS7FfgBT-Bzdk7Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/11/2011 04:12 AM, Gertjan van Wingerde wrote:
> On Mon, Apr 11, 2011 at 5:06 AM, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>> Hi,
>>
>> I am in the process of updating the firmware files for rt2800pci and
>> rt2800usb. If you have one of the devices that use this driver, please test
>> the firmware file.
>>
>
> Cannot test these specific files right now, but Ralink does provide
> firmware files
> under these names that support all known devices supported by rt2800pci and
> rt2800usb (if they are recent enough).
> Back home I'm using slightly older versions of the firmware files on all devices
> that I have (which does span RT2860 PCI, RT3090 PCIe, RT3562 PCI (driving not
> working), RT2870, RT2070, RT3070, RT3071, RT3072, RT3370, RT3572 (driver not
> working)).
>
> Where did you get these specific files from?
>
> I recommend using the ones that Ralink sent for inclusion in the since
> these will
> support even the newest devices (RT5370/RT5390).

They came from
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-March/003381.html

and

http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-March/003382.html.

These were the Ralink submissions to linux-firmware that did not get accepted or 
rejected.

Once ralinktech.com.tw comes back up, I will grab the files from there and make 
a comparison.

Larry


