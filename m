Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li59-9.members.linode.com ([97.107.129.9]:48745 "EHLO erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab0BEFQL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 00:16:11 -0500
Message-ID: <4B6BA999.4030904@erley.org>
Date: Fri, 05 Feb 2010 00:16:09 -0500
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Holger Schurig <holgerschurig@gmail.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Linux wireless GSoC 2010 project ideas
References: <43e72e891001281338u5f05307ble5360c3dac6ab9a2@mail.gmail.com> 	<20100201221252.GA30758@emergent.ellipticsemi.com> <4B67A937.70406@erley.org> 	<201002031025.04624.holgerschurig@gmail.com> <9e52624fd81bc62bd917b1ad696b9535@127.0.0.1> <43e72e891002031048l65f8ac0ewf1de6f48b8ac46ec@mail.gmail.com>
In-Reply-To: <43e72e891002031048l65f8ac0ewf1de6f48b8ac46ec@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/03/10 13:48, Luis R. Rodriguez wrote:
> On Wed, Feb 3, 2010 at 6:24 AM,  <pat-lkml@erley.org> wrote:
>> On Wed, 3 Feb 2010 10:25:04 +0100, Holger Schurig
>> <holgerschurig@gmail.com>
>> wrote:
>>>> With ath9k I have used:
>>>>
>>>> AP + MP
>>>> AP + STA
>>>> AP + AP (Open and WPA2)
>>>
>>> Would you document this on the wireless WIKI at
>>> wireless.kernel.org ?
>>>
>>> Maybe as different articles, so that this can be a basis of
>>> several "HOWTO" articles.
>>
>> Yeah, I will try to find the time soon.  Any hints as to what needs to be
>> documented?  It is, at least in my opinion, pretty trivial to pull off, so
>> I'm not certain that anything more than an entry explaining how to create
>> additional interfaces is necessary.  Feel free to throw some ideas as to
>> what all you'd like to see in the documentation, and I'll write it (them?)
> 
> The ath9k virtual wiphy stuff is private to ath9k so for that you can
> add it here:
> 
> http://wireless.kernel.org/en/users/Drivers/ath9k/debug#wiphy
> 
> For things that are specific to mac80211 that do not require the ath9k
> virtual wiphy something on the root of this page might be better:
> 
> http://wireless.kernel.org/en/users/Documentation
> 
> If ath9k virtual wiphy is quite useful today we would have to ensure
> any possible replacement would meet up to match its capabilities. I
> was unaware anyone was yet using it and testing it extensively. Have
> you been doing these tests on the virtual wiphy with a fairly recent
> snapshot?

I tinker with the mac80211 interface to it a lot (a project on my d-link dir-615).  I'm doing a pseudo wds setup or client/AP setup, whatever you'd call that - essentially, a range extender.  I have some other hardware that I tinker with multiple APs using hostapd, as well as MP+AP for fun.  All the systems are wired together, so it's not a big deal for me if I break things, hence all the tinkering.  

As far as snapshots, I am using a lightly modded compat-wireless+compat from git that works with wireless-testing.  I update every 2-3 days.  Before mac80211 supported multiple vifs, I was testing with the ath9k interface exclusively.

Do you guys think the content would be better placed onto the iw page, or onto a separate one?  I don't think there's enough content (yet?) unless i make it an all inclusive set of pages that explain the use of all of the modes, and whatnot.  I'd only planned on tackling the creation and configuration of the wireless side of things, leaving the IP steps out, because it seems like that's outside the 'scope' of the wireless wiki?

Pat
