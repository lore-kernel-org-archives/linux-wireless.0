Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc3-s36.bay0.hotmail.com ([65.54.246.236]:4787 "EHLO
	bay0-omc3-s36.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752267AbYCTClC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 22:41:02 -0400
Message-ID: <BAY101-W21790F71EFEF146FF9E2AC8000@phx.gbl> (sfid-20080320_024109_572319_51BB21D3)
From: Adam Turk <bofh1234@hotmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: RE: 2.6.25-rc6, rausb0 or wlan0 or both???
Date: Wed, 19 Mar 2008 22:41:00 -0400
In-Reply-To: <1205976828.16475.92.camel@johannes.berg>
References: <BAY101-W2F265A1ACEEAD6E11D953C8000@phx.gbl>
	 (sfid-20080320_011109_826246_EC8219A9)
 <1205976828.16475.92.camel@johannes.berg>
Content-Type: text/plain; charset=iso-8859-1
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Subject: Re: 2.6.25-rc6, rausb0 or wlan0 or both???
> From: johannes@sipsolutions.net
> To: bofh1234@hotmail.com
> CC: linux-wireless@vger.kernel.org
> Date: Thu, 20 Mar 2008 02:33:48 +0100
>
>
>> When I do the airmon-ng start wlan0 I get the following error messag=
e:
>> Interface Chipset Driver
>> wlan0 Ralink 2573 USB rt73usb - [phy0]
>>
>> ERROR: Neither the sysfs interface links nor the iw command is avail=
able.
>> Please download and install iw from http://git.sipsolutions.net/iw.g=
it
>>
>> If I do a airmon-ng start rausb0 I don't get the error, but the pack=
et
>> injection test doesn't succeed. I am using aircrack beta 2 version
>> 1007
>>
>> Can this please get fixed for 2.6.25?
>
> Have you considered reading the error message?
>
> johannes

Yes I did check the website listed, but I didn't see anything there tha=
t would explain how to use the website, or fix the problem.  I don't kn=
ow how to use git.  I am just an enduser testing the kernel.  This of c=
ourse begs the question of why is the kernel dependent on something tha=
t is not in mainline to work properly?

Thanks,

_________________________________________________________________
Helping your favorite cause is as easy as instant messaging.=A0You IM, =
we give.
http://im.live.com/Messenger/IM/Home/?source=3Dtext_hotmail_join--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
