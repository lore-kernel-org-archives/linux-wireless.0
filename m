Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:46056 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934171AbZGQIBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 04:01:00 -0400
Message-ID: <4A602FBA.2010808@canonical.com>
Date: Fri, 17 Jul 2009 10:00:58 +0200
From: Stefan Bader <stefan.bader@canonical.com>
MIME-Version: 1.0
To: Ivo Van Doorn <ivdoorn@gmail.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Manoj Iyer <manoj.iyer@canonical.com>,
	kernel-team@lists.ubuntu.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [KARMIC] review these for rt2x00 (adds rt2800pci)
References: <43e72e890907161615h507e9c59r421d23d22ff05459@mail.gmail.com> <a32f33a40907170011n38367961i54a26c50124241c2@mail.gmail.com>
In-Reply-To: <a32f33a40907170011n38367961i54a26c50124241c2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo Van Doorn wrote:
> On Fri, Jul 17, 2009 at 1:15 AM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
>> On Thu, Jul 16, 2009 at 9:56 AM, Stefan Bader<stefan.bader@canonical.com> wrote:
>>> At least this seems to be material for 3 or 4 patches
>>> - adapt the rfkill stuff
>>> - some documentation update
>>> - add the new pci version of the 2800 (with that rt2x00soc lib
>>>   which might be another patch)
>>> - and some fixes...
>> Not only that but this driver is not yet merged upstream, there should
>> be a good reason for that.
>>
>> Ivo, what's the status on rt2800pci? Some users have been asking about it.
> 
> The status is that it is not functioning correctly, during boot it
> will print out
> tons of errors about the device not being ready, and afterward it cannot scan,
> connect or do anything useful.
> 
> And I think those problems can be considered enough reasons for not merging
> the driver upstream yet. ;)
> 
> Ivo

I would say so. :) Assuming there is a bit of truth in those claims of that 
tarball working better than the current kernel code, we might take away all the 
new driver bloat and see what remains (which might be the part Ivo has anyways 
in wireless testing...)

Stefan

-- 

When all other means of communication fail, try words!


