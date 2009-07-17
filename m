Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:18936 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964847AbZGQQA7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 12:00:59 -0400
Received: by wf-out-1314.google.com with SMTP id 26so278167wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2009 09:00:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A602FBA.2010808@canonical.com>
References: <43e72e890907161615h507e9c59r421d23d22ff05459@mail.gmail.com>
	<a32f33a40907170011n38367961i54a26c50124241c2@mail.gmail.com>
	<4A602FBA.2010808@canonical.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 17 Jul 2009 09:00:39 -0700
Message-ID: <43e72e890907170900r401a0b46tc56736f88d4436a2@mail.gmail.com>
Subject: Re: [KARMIC] review these for rt2x00 (adds rt2800pci)
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	Manoj Iyer <manoj.iyer@canonical.com>,
	kernel-team@lists.ubuntu.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 17, 2009 at 1:00 AM, Stefan Bader<stefan.bader@canonical.com> wrote:
> Ivo Van Doorn wrote:
>>
>> On Fri, Jul 17, 2009 at 1:15 AM, Luis R. Rodriguez<mcgrof@gmail.com>
>> wrote:
>>>
>>> On Thu, Jul 16, 2009 at 9:56 AM, Stefan Bader<stefan.bader@canonical.com>
>>> wrote:
>>>>
>>>> At least this seems to be material for 3 or 4 patches
>>>> - adapt the rfkill stuff
>>>> - some documentation update
>>>> - add the new pci version of the 2800 (with that rt2x00soc lib
>>>>  which might be another patch)
>>>> - and some fixes...
>>>
>>> Not only that but this driver is not yet merged upstream, there should
>>> be a good reason for that.
>>>
>>> Ivo, what's the status on rt2800pci? Some users have been asking about
>>> it.
>>
>> The status is that it is not functioning correctly, during boot it
>> will print out
>> tons of errors about the device not being ready, and afterward it cannot
>> scan,
>> connect or do anything useful.
>>
>> And I think those problems can be considered enough reasons for not
>> merging
>> the driver upstream yet. ;)
>>
>> Ivo
>
> I would say so. :) Assuming there is a bit of truth in those claims of that
> tarball working better than the current kernel code, we might take away all
> the new driver bloat and see what remains (which might be the part Ivo has
> anyways in wireless testing...)

Its not part of wireless-testing.

 Luis
