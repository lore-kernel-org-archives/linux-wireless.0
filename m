Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f173.google.com ([209.85.222.173]:49666 "EHLO
	mail-pz0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab0BEPtf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 10:49:35 -0500
Received: by pzk3 with SMTP id 3so1036335pzk.5
        for <linux-wireless@vger.kernel.org>; Fri, 05 Feb 2010 07:49:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B6BA999.4030904@erley.org>
References: <43e72e891001281338u5f05307ble5360c3dac6ab9a2@mail.gmail.com>
	<20100201221252.GA30758@emergent.ellipticsemi.com> <4B67A937.70406@erley.org>
	<201002031025.04624.holgerschurig@gmail.com> <9e52624fd81bc62bd917b1ad696b9535@127.0.0.1>
	<43e72e891002031048l65f8ac0ewf1de6f48b8ac46ec@mail.gmail.com>
	<4B6BA999.4030904@erley.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 5 Feb 2010 07:49:15 -0800
Message-ID: <43e72e891002050749k65f36f24hcfa516cd5363a675@mail.gmail.com>
Subject: Re: Linux wireless GSoC 2010 project ideas
To: Pat Erley <pat-lkml@erley.org>
Cc: Holger Schurig <holgerschurig@gmail.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 4, 2010 at 9:16 PM, Pat Erley <pat-lkml@erley.org> wrote:
> On 02/03/10 13:48, Luis R. Rodriguez wrote:
>> On Wed, Feb 3, 2010 at 6:24 AM,  <pat-lkml@erley.org> wrote:
>>> On Wed, 3 Feb 2010 10:25:04 +0100, Holger Schurig
>>> <holgerschurig@gmail.com>
>>> wrote:
>>>>> With ath9k I have used:
>>>>>
>>>>> AP + MP
>>>>> AP + STA
>>>>> AP + AP (Open and WPA2)
>>>>
>>>> Would you document this on the wireless WIKI at
>>>> wireless.kernel.org ?
>>>>
>>>> Maybe as different articles, so that this can be a basis of
>>>> several "HOWTO" articles.
>>>
>>> Yeah, I will try to find the time soon.  Any hints as to what needs to be
>>> documented?  It is, at least in my opinion, pretty trivial to pull off, so
>>> I'm not certain that anything more than an entry explaining how to create
>>> additional interfaces is necessary.  Feel free to throw some ideas as to
>>> what all you'd like to see in the documentation, and I'll write it (them?)
>>
>> The ath9k virtual wiphy stuff is private to ath9k so for that you can
>> add it here:
>>
>> http://wireless.kernel.org/en/users/Drivers/ath9k/debug#wiphy
>>
>> For things that are specific to mac80211 that do not require the ath9k
>> virtual wiphy something on the root of this page might be better:
>>
>> http://wireless.kernel.org/en/users/Documentation
>>
>> If ath9k virtual wiphy is quite useful today we would have to ensure
>> any possible replacement would meet up to match its capabilities. I
>> was unaware anyone was yet using it and testing it extensively. Have
>> you been doing these tests on the virtual wiphy with a fairly recent
>> snapshot?
>
> I tinker with the mac80211 interface to it a lot (a project on my d-link dir-615).  I'm doing a pseudo wds setup or client/AP setup, whatever you'd call that - essentially, a range extender.  I have some other hardware that I tinker with multiple APs using hostapd, as well as MP+AP for fun.  All the systems are wired together, so it's not a big deal for me if I break things, hence all the tinkering.
>
> As far as snapshots, I am using a lightly modded compat-wireless+compat from git that works with wireless-testing.  I update every 2-3 days.  Before mac80211 supported multiple vifs, I was testing with the ath9k interface exclusively.
>
> Do you guys think the content would be better placed onto the iw page, or onto a separate one?

iw command stuff should go on the iw page
ath9k virtual wiphy stuff on the ath9k/debug page

If there is something else you'd like to cover like AP + MP solution
together perhaps adding a new page would be best.

  Luis
