Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:44461 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752986AbYIGAc6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 20:32:58 -0400
Message-ID: <48C32138.4000700@lwfinger.net> (sfid-20080907_023301_936959_019D6F3E)
Date: Sat, 06 Sep 2008 19:32:56 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Pavel Roskin <proski@gnu.org>, Tomas Winkler <tomasw@gmail.com>
Subject: Re: [PATCH v2] p54usb: support LM87 firmwares
References: <200809022139.12969.chunkeey@web.de> <200809070119.45720.chunkeey@web.de> <48C31349.7060401@lwfinger.net> <200809070225.41177.chunkeey@web.de>
In-Reply-To: <200809070225.41177.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chr wrote:
> On Sunday 07 September 2008 01:33:29 Larry Finger wrote:
>> Chr wrote:
>>> But, for newer firmwares you'll need "p54: better firmware support"
>>> (cc4b0cbf4ab) as well. This changes were merged about 25-26 hours ago
>>> into wireless-testing, the only thing that isn't in yet is 802.11a
>>> support....
>>>
>>> the LM87 firmware is this one:
>>> http://daemonizer.de/prism54/prism54-fw/fw-usb/2.13.1.0.arm.1
>>>
>>> This link can be found on the driver's site too:
>>> http://linuxwireless.org/en/users/Drivers/p54
>> Thanks. That one fixed the ping problem. I had the latest
>> wireless-testing, and have added the patches you posted earlier today.
>>
> Well, since you already do some testing here.  Want more? ;-)
> 
> I will be off for about 4-5 weeks and it would be very nice if someone with lots of broadcom
> hardware can test if the p54 works ADHOC & AP mode with them.
> 
> i've already (successfully) tested Intel's 2915 & 4965, several atheros chipsets and another prism54
> on different operating systems.
> 
> But there could be problems with some broadcom chips.

I'll see what I can do.

After loading the new firmware, p54usb crapped out after the following 
message was logged:

phy9: not handling 0x02 type control frame

After this, I had to unload and reload the driver. I have not yet had 
time to check on it.

Larry


