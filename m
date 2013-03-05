Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:61511 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab3CERlr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 12:41:47 -0500
Received: by mail-oa0-f42.google.com with SMTP id i18so11425870oag.29
        for <linux-wireless@vger.kernel.org>; Tue, 05 Mar 2013 09:41:46 -0800 (PST)
Message-ID: <51362E58.7010004@lwfinger.net> (sfid-20130305_184150_773079_75742C28)
Date: Tue, 05 Mar 2013 11:41:44 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Stations disconnected due to no activity in latest wireless-testing.
References: <513627C4.5040207@candelatech.com> <513629CE.4020307@lwfinger.net> <51362BA4.3020104@candelatech.com>
In-Reply-To: <51362BA4.3020104@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/05/2013 11:30 AM, Ben Greear wrote:
> On 03/05/2013 09:22 AM, Larry Finger wrote:
>> On 03/05/2013 11:13 AM, Ben Greear wrote:
>>> I'm trying the 3.9.0-rc1-wl+, and wlan0 is disconnecting almost immediately
>>> after it connects, supposedly because of inactivity....
>>>
>>> Is this a known issue?
>>
>> Not here. Which driver or drivers are involved? I have tested with b43 on a
>> BCM4312 and rtl8723ae.
>
>
> ath9k.  Same system works great on our 3.7 kernel, so I don't think it's
> a user-space issue, at least (our supplicant and hostapd is not the absolute
> latest,
> but it's not that old either).

It is not convenient for me to test with ath9k at the moment, but ath9k_htc is 
OK. My distro is openSUSE 12.3-RC2 (released Feb 28), thus the supplicant is 
relatively new (version 1.1). I am using my wireless devices as STA only, thus 
hostapd is not in play.

Larry


