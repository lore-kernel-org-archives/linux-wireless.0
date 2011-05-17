Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gunnarstahl.de ([83.169.3.122]:46976 "EHLO
	lvps83-169-3-122.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932086Ab1EQTqK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 15:46:10 -0400
Message-ID: <4DD2C8AE.3090600@gunnarstahl.org> (sfid-20110517_214614_145093_09587079)
Date: Tue, 17 May 2011 21:12:46 +0200
From: Gunnar Stahl <gunnar.stahl@gunnarstahl.org>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: =?UTF-8?B?UmljaGFyZCBTY2jDvHR6?= <r.schtz@t-online.de>,
	ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	622753@bugs.debian.org, Adrian Chadd <adrian@freebsd.org>
References: <20110414123925.31837.14741.reportbug@noomadix>	 <1302785635.5282.690.camel@localhost> <4DA6EEF8.9090701@t-online.de>	 <1302840012.5282.745.camel@localhost>	 <BANLkTikr6LBGPf8roLyf9n9yL=7qk4y72g@mail.gmail.com> <1305603920.19966.119.camel@localhost>
In-Reply-To: <1305603920.19966.119.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Subject: Re: ath9k: Connection over wlan slows down and dies
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,
since sunday I am running kernel 2.6.38-2-amd64 (uname -a) (dselect version 2.6.38-5). The wlan module works now almost 
perfect. The "almost" is due to the fact that connection the machine to the android hotspot somehow fails. But all other 
hotspots I used until now work as expected.

Huge thank-you from me!

Yt,

Gunnar

Am 17.05.2011 05:45, schrieb Ben Hutchings:
> On Fri, 2011-04-15 at 15:52 +0800, Adrian Chadd wrote:
>> On 15 April 2011 12:00, Ben Hutchings<ben@decadent.org.uk>  wrote:
>>          [...]
>>          >  https://bugzilla.kernel.org/show_bug.cgi?id=31452
>>
>>
>>          Thanks, I've set our bug tracker to follow that bug.
>>
>> Has it been established that it's the same bug though?
>>
>> I had a brief read of that and I'm not so sure. There's so many things
>> that could impact TX throughput.
>>
>> I don't have this problem on FreeBSD on my AR9285 NICs and I've ported
>> almost all of the (non-power saving) related code from ath9k. They
>> happily sit at the expected TX/RX speeds in 11g and 11n modes.
>>
>> Is someone who is experiencing the problem able to do some kernel
>> version bisecting between the known good and known bad kernel?
> The bug fix from the report on Bugzilla has been included in stable
> release 2.6.38.5 and Debian's version 2.6.38-5.
>
> Does this version fix the problem for you?
>
> Ben.
>

