Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:60845 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605Ab3HFQva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 12:51:30 -0400
Received: by mail-wg0-f45.google.com with SMTP id x12so584232wgg.12
        for <linux-wireless@vger.kernel.org>; Tue, 06 Aug 2013 09:51:29 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUVRgVfXUdJ1xoaN=nciqZDhV-f6EbH+6DS7HAh+My65oQ@mail.gmail.com>
References: <CA+icZUX8OcTSOABO6Nbz5R6_5-m39rsYOpDqYBA7hf8LFvJLLA@mail.gmail.com>
	<1375797260.8219.21.camel@jlt4.sipsolutions.net>
	<CA+icZUUAJ25QybqHvxz7eubSLH6YuNjcc5zyU2O5Xi9vevMGkw@mail.gmail.com>
	<1375800617.8219.23.camel@jlt4.sipsolutions.net>
	<CA+icZUVbKpyuke6PRg3-60gOggsTb=3cNRz3Sy0RmvcZSuPaNw@mail.gmail.com>
	<1375801059.8219.24.camel@jlt4.sipsolutions.net>
	<CA+icZUXrRsXfeW9hqxTMkKW4TdNSBH-zE8-zX2Rd7HTAx5MvqQ@mail.gmail.com>
	<CA+icZUWijPJmNoqE22Msqcn7tRot3SB3e=KujMM7JNd-Om-oOw@mail.gmail.com>
	<1375802297.8219.25.camel@jlt4.sipsolutions.net>
	<CA+icZUVCFOS6SHonEqzaJyWCGCU4nqqGjBN0VbmV-=OoM+deZg@mail.gmail.com>
	<CA+icZUVuOqdZUGy2ALAF1CehOqYdr7rtEsXhqNvDtYEns2BuRQ@mail.gmail.com>
	<1375802993.8219.26.camel@jlt4.sipsolutions.net>
	<CA+icZUW6P9Z_7z+o+z=qBWSFzyU8tgtY0ou+rmLcEzWbn94OXA@mail.gmail.com>
	<CA+icZUW7LVzg7sM3O-w5oQpeaj=CT6MS6Q7cRZ1qK0h-Z4wZuw@mail.gmail.com>
	<1375804998.8219.27.camel@jlt4.sipsolutions.net>
	<CA+icZUVRgVfXUdJ1xoaN=nciqZDhV-f6EbH+6DS7HAh+My65oQ@mail.gmail.com>
Date: Tue, 6 Aug 2013 18:51:29 +0200
Message-ID: <CA+icZUUmQbovkwXcdEp6eu=WJkiuiyO8nDVwCHFUuPDbJqU7Kg@mail.gmail.com> (sfid-20130806_185134_147573_BDFF43FD)
Subject: Re: linux-next: Tree for Aug 6 [ wireless | iwlwifi | mac80211 ? ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 6, 2013 at 6:07 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Tue, Aug 6, 2013 at 6:03 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> [reducing mailing lists - Stephen if you want off let us know]
>>
>> On Tue, 2013-08-06 at 17:58 +0200, Sedat Dilek wrote:
>>
>>> $ cat /proc/version
>>> Linux version 3.11.0-rc4-1-wl-20130805 (sedat.dilek@gmail.com@fambox)
>>> (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #1 SMP Tue Aug 6
>>> 17:52:45 CEST 2013
>>>
>>> This kernel boots fine and has no WiFi problems.
>>>
>>> > You assume a breakage in a different area than wireless or network in general?
>>> >
>>>
>>> Any wild guess?
>>
>> Not really, but maybe you can pull the other trees on top again and see
>> if those broke it? I don't really think/hope so but it's possible that
>> one of my pending pull requests broke it, I guess?
>>
>
> Hmm, I pulled in latest for-john of mac80211(-next) and
> iwlwifi-(fixes|next) which did not help.
>
> I am testing next-20130805 and next-20130802 to identify which
> Linux-next release is BROKEN.
>

GOOD: next-20130801 and next-20130802

BROKEN: next-20130805 and next-20130806

Comparing diffs between next-20130802 and next-20130805.

- Sedat -
