Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f42.google.com ([74.125.83.42]:43285 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab1IRXFY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Sep 2011 19:05:24 -0400
Received: by gwb17 with SMTP id 17so6034448gwb.1
        for <linux-wireless@vger.kernel.org>; Sun, 18 Sep 2011 16:05:24 -0700 (PDT)
Message-ID: <4E767934.3000502@lwfinger.net> (sfid-20110919_010528_651401_112638D6)
Date: Sun, 18 Sep 2011 18:05:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Manuel Munz <freifunk@somakoma.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: No beacons in ad-hoc mode with b43
References: <4E751496.30903@somakoma.de> <4E766435.3010707@somakoma.de>
In-Reply-To: <4E766435.3010707@somakoma.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/18/2011 04:35 PM, Manuel Munz wrote:
> On 17.09.2011 23:43, Manuel Munz wrote:
>> Hi,
>>
>> i want to use b43 on older broadcom wireless routers with openwrt, but
>> there seems to be a problem: The router doesn't send beacons in adhoc
>> mode (verified with wireshark), which means users can't see the network
>> in a network scan. So is there a problem in the adhoc implementation
>> with b43? Could someone please have a look at this? It is preventing us
>> from using b43 in our mesh for too long now.
>>
>
> Hi,
>
> after trying various things i came up with the following patch which
> seems to address the issue for me.

I confirmed your fix with an ad-hoc connection from one b43 device to another.

Your patch needs to be reformatted to satisfy kernel requirements. I will take 
care of that for you, but you need to read Documentation/SubmittingPatches.

Good work to find the fix.

Larry

