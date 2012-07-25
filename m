Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61037 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab2GYWz4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 18:55:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120723192057.GE18589@tuxdriver.com>
References: <20120322192406.GB2432@tuxdriver.com>
	<1332698585.1870.88.camel@aeonflux>
	<20120326145433.GE13806@tuxdriver.com>
	<1332774906.1870.98.camel@aeonflux>
	<20120326152541.GH13806@tuxdriver.com>
	<20120427174439.GC16207@tuxdriver.com>
	<20120723192057.GE18589@tuxdriver.com>
Date: Thu, 26 Jul 2012 01:55:55 +0300
Message-ID: <CAFtRNNzfbWkQnwnkiDjU3HvwbLynNkNyeTff=a4N7LWH6dhcmg@mail.gmail.com> (sfid-20120726_005602_155686_273C2AE9)
Subject: Re: 2nd CFP -- Linux Wireless (802.11/Bluetooth/NFC) Mini-Summit 2012 (Barcelona!)
From: Nick Kossifidis <mickflemm@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	alexander.smirnov@siemens.com, Sergey.Sobolev@siemens.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/7/23 John W. Linville <linville@tuxdriver.com>:
> On Fri, Apr 27, 2012 at 01:44:39PM -0400, John W. Linville wrote:
>
>> Just to keep the ball rolling...
>>
>> Angela has reserved space for us at the Hotel Fira
>> Palace for the Wireless Summit on Thurs, Nov 8th and Fri, Nov 9th.
>> Please note that this will overlap Yocto Dev Days, oVirt Summit and
>> KVM Forum at the same venue.
>>
>> Now, we need some talk proposals!  Please post in this thread (or
>> contact me or Marcel directly if necessary) to propose talks.  I would
>> love to see any topics on any relevant technologies, as well as topics
>> about how the projects are being managed, new sub-projects, etc.
>> It seems like a long time away right now, but it is a good time to
>> start thinking... :-)
>
> Still a while to go, but this event is getting closer.  I would love to
> see some more concrete topic proposals for talks, both presentations
> and discussions.
>
> Here is what I've seen so far:
>
> Speaker                         Topic
> -------                         -----
> Joao Paulo Rechi Vita           status and roadmap of Bluetooth LE
> Andrei Emeltchenko              Virtual Bluetooth AMP Controller for mac80211
> Alexander Smirnov               802.15.4 stack, 6lowpan
>
> Not bad, but I'd like to see some more!  Some ideas:
>
>         -- "state of the union" for bluetooth, nfc, 802.11
>         -- wireless mesh networking status updates
>         -- cfg80211/mac80211 feature previews (what's coming?)
>         -- standards bodies reports (802.11, 802.15.x)
>         -- important or unusual use cases (e.g. Freifunk, Internet of Things)
>         -- userland wireless management apps (NetworkManager, connman)
>         -- wireless-oriented (or wireless-specific) applications
>         -- issues with managing a wireless networking sub-tree
>         -- long-term support for legacy hardware (Intel?  Atheros?)
>         -- driver projects without hardware vendor support?
>         -- staging driver migration?  out-of-tree driver merging?
>         -- ???
>
> I'm sure there are worthwhile topics that I didn't suggest yet --
> feel free to suggest your own!  And if you can address one of those
> topics or one of your own, please reply either to this thread or
> directly to me.
>
> Please note -- you do not necessarily to be a kernel developer (or a
> developer at all) to merit a speaking slot!  Anyone with a topic to
> propose will receive appropriate consideration.
>
> So, let's hear it! :-)
>
> John
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Since this time the summit is in Europe I'll try to make it there, if
I do I 'd like to give a talk on wireless community networks and the
work we 've done so far. In Barcelona we have the largest wireless
community network worldwide with over 10.000 nodes called Guifi.net
(Athens comes next with awmn, check it out  @ wind.awmn.net -more than
2.500 nodes, in 2002 I set up the first rooftop-pc there :P) so it'll
be great if we could arrange a meeting or a tour or something.

Anyway what I'd like to do is give you an idea on how our code is
being used not only to create huge wireless community networks around
the world (in 2009 we had the International Summit for Community
Wireless Networks in Vienna and the next one is in Barcelona on
October, more infos here -> http://wirelesssummit.org/) but also on
research, activism etc.

Also I'd like to give you some updates on how spectrum policies evolve
and what we are trying to do on OSA (that's Open Spectrum Alliance
http://www.openspectrum.eu/drupal6/) to get more free spectrum to play
with.


-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
