Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:39642 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415Ab0A3RVc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2010 12:21:32 -0500
Message-ID: <4B646A9A.80709@openwrt.org>
Date: Sat, 30 Jan 2010 18:21:30 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Greg Oliver <oliver.greg@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Multiple SSID on same phy
References: <20100129122718.73a6c877@nehalam>	 <1264866128.3546.185.camel@johannes.local>	 <51058d551001300751r4a509e90i521c946dfe9dec4@mail.gmail.com>	 <1264867217.3546.186.camel@johannes.local>	 <51058d551001300814y66d1d589uae15fa50086593b8@mail.gmail.com>	 <1264868231.3546.188.camel@johannes.local>	 <51058d551001300822p7ab564e4jedd6faad380dabc@mail.gmail.com>	 <4B6466E9.90705@openwrt.org> <51058d551001300911te9133e8we169a0c839734f7b@mail.gmail.com>
In-Reply-To: <51058d551001300911te9133e8we169a0c839734f7b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-01-30 6:11 PM, Greg Oliver wrote:
> On Sat, Jan 30, 2010 at 11:05 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>> On 2010-01-30 5:22 PM, Greg Oliver wrote:
>>> On Sat, Jan 30, 2010 at 10:17 AM, Johannes Berg
>>> <johannes@sipsolutions.net> wrote:
>>>> On Sat, 2010-01-30 at 10:14 -0600, Greg Oliver wrote:
>>>>> On Sat, Jan 30, 2010 at 10:00 AM, Johannes Berg
>>>>> <johannes@sipsolutions.net> wrote:
>>>>> > I suggest you go public with your reply so you can be flamed and taught
>>>>> > wrong appropriately.
>>>>>
>>>>> Sorry - this gmail inefficiency sometimes gets me...
>>>>>
>>>>> BUT, please enlighten me when any of the 3 use cases would be
>>>>> beneficial to anyone not trying to (or "inefficiently migrating") hack
>>>>> into a network would occur.
>>>>
>>>> I don't think I can parse that. In any case, a possible use case would
>>>> for instance be a protected company network, along with an unprotected,
>>>> internet-only guest network.
>>> Hmmm, I would put the odds at that happening about 100,000:1 (if not more)
>>>
>>> Yes, I know it is feasible, but HIGHLY unlikely.
>> Actually, with non-mac80211 drivers people have been deploying setups
>> like this for years. Now that this functionality is starting to
>> stabilize in mac80211, people are starting to use it there as well.
>>
>> What you call 'HIGHLY unlikely' is actually very common ;)
>>
>> - Felix
>>
> 
> Hmmm..  Are there that many network engineers that I clean the mess up
> for?  I think they would not be visiting here...  Please give me an
> example of "hiding" anything..  That just makes it all more useless..
> Seriously real world examples that only a single ssid would benefit
> from..
> 
> I can think of no reason you would not EVER use a unique name....
I seem to have trouble parsing your language as well.
I thought we were talking about the use case of having two distinct BSS
interfaces with different SSIDs on the same PHY.
What does that have to do with hiding anything? Different interfaces,
different encryption settings, bound to different networks, simple as that.

- Felix
