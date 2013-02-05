Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moh1-ve2.go2.pl ([193.17.41.132]:59930 "EHLO moh1-ve2.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974Ab3BEWjZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 17:39:25 -0500
Received: from moh1-ve2.go2.pl (unknown [10.0.0.132])
	by moh1-ve2.go2.pl (Postfix) with ESMTP id D78B11044009
	for <linux-wireless@vger.kernel.org>; Tue,  5 Feb 2013 23:39:13 +0100 (CET)
Received: from unknown (unknown [10.0.0.42])
	by moh1-ve2.go2.pl (Postfix) with SMTP
	for <linux-wireless@vger.kernel.org>; Tue,  5 Feb 2013 23:39:13 +0100 (CET)
Date: Tue, 5 Feb 2013 23:39:08 +0100
From: Tomasz Guszkowski <tsg@o2.pl>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] p54usb: corrected USB ID for T-Com Sinus 154 data II
Message-Id: <20130205233908.0fd8a9a0a58e940e54e86c15@o2.pl> (sfid-20130205_233928_464968_7CDF7D30)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 5 Feb 2013, Christian Lamparter wrote:

> (Added John [He takes all the driver patches ;).
>
> John, do you want/need a line-wrapped commit message
> of the original patch or is this OK?)
>
> On Tuesday, February 05, 2013 10:10:31 PM Tomasz Guszkowski wrote:
>> Corrected USB ID for T-Com Sinus 154 data II. ISL3887-based.
>> The device was tested in managed mode with no security, WEP
>> 128 bit and WPA-PSK (TKIP) with firmware 2.13.1.0.lm87.arm
>> (md5sum: 7d676323ac60d6e1a3b6d61e8c528248). It works.
>>
>> Signed-off-by: Tomasz Guszkowski <tsg@o2.pl>
> Cc: <stable@vger.kernel.org>
> Acked-By: Christian Lamparter <chunkeey@googlemail.com>
>> ---
>
> I'll take care of updating the wireless.kernel.org wiki
> <http://wireless.kernel.org/en/users/Drivers/p54/devices>
> entry later this week.
>
> OT: The latest supported firmware for LM87 is: 2.13.25.0.lm87.arm
> Did you experience issues with the new version, or do you simply
> stick with the old 2.13.1.0 because it does work just as well?

I stayed with 2.13.1.0, because it was the first version that
worked.

You had triggered my curiosity. I have just done a fast test with 
2.13.25.0.lm87.arm (md5sum: 39be687c87544b892e7a8ffe7ffd9371) 
and "iwlist wlan0 scan" found several networks, so it seems
to work. Unfortunately, at the moment I have no own network at hand,
so can't try connecting. I will do more thorough tests soon, maybe
tomorrow, and let you know about the results.

Tomek
