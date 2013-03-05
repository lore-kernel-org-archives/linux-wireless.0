Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43238 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694Ab3CERkF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 12:40:05 -0500
Message-ID: <51362CC6.3060504@candelatech.com> (sfid-20130305_184012_515349_48B1F33D)
Date: Tue, 05 Mar 2013 09:35:02 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Stations disconnected due to no activity in latest wireless-testing.
References: <513627C4.5040207@candelatech.com> <513629CE.4020307@lwfinger.net> <51362BA4.3020104@candelatech.com>
In-Reply-To: <51362BA4.3020104@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/05/2013 09:30 AM, Ben Greear wrote:
> On 03/05/2013 09:22 AM, Larry Finger wrote:
>> On 03/05/2013 11:13 AM, Ben Greear wrote:
>>> I'm trying the 3.9.0-rc1-wl+, and wlan0 is disconnecting almost immediately
>>> after it connects, supposedly because of inactivity....
>>>
>>> Is this a known issue?
>>
>> Not here. Which driver or drivers are involved? I have tested with b43 on a BCM4312 and rtl8723ae.
>
>
> ath9k.  Same system works great on our 3.7 kernel, so I don't think it's
> a user-space issue, at least (our supplicant and hostapd is not the absolute latest,
> but it's not that old either).

Hmm, I had a bunch of 'admin down' virtual stations.  I deleted all of those
and restarted supplicant and hostapd (on the station and AP machine, respectively)
and now it works ok.  Added back another station, and it still works.

So, must be something funky..I'll dig into it more if I hit it
again.

Ben

>
> Thanks,
> Ben
>
>>
>> Larry
>>
>
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

