Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f197.google.com ([209.85.222.197]:48426 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934749AbZGQQyP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 12:54:15 -0400
Received: by pzk35 with SMTP id 35so702863pzk.33
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2009 09:54:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907171836.04947.IvDoorn@gmail.com>
References: <43e72e890907161615h507e9c59r421d23d22ff05459@mail.gmail.com>
	<4A602FBA.2010808@canonical.com> <43e72e890907170900r401a0b46tc56736f88d4436a2@mail.gmail.com>
	<200907171836.04947.IvDoorn@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 17 Jul 2009 09:53:54 -0700
Message-ID: <43e72e890907170953k6985ecc2o508481c713b0bacc@mail.gmail.com>
Subject: Re: [KARMIC] review these for rt2x00 (adds rt2800pci)
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Stefan Bader <stefan.bader@canonical.com>,
	Manoj Iyer <manoj.iyer@canonical.com>,
	kernel-team@lists.ubuntu.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 17, 2009 at 9:36 AM, Ivo van Doorn<ivdoorn@gmail.com> wrote:
> On Friday 17 July 2009, Luis R. Rodriguez wrote:
>> On Fri, Jul 17, 2009 at 1:00 AM, Stefan Bader<stefan.bader@canonical.com> wrote:
>> > Ivo Van Doorn wrote:
>> >>
>> >> On Fri, Jul 17, 2009 at 1:15 AM, Luis R. Rodriguez<mcgrof@gmail.com>
>> >> wrote:
>> >>>
>> >>> On Thu, Jul 16, 2009 at 9:56 AM, Stefan Bader<stefan.bader@canonical.com>
>> >>> wrote:
>> >>>>
>> >>>> At least this seems to be material for 3 or 4 patches
>> >>>> - adapt the rfkill stuff
>> >>>> - some documentation update
>> >>>> - add the new pci version of the 2800 (with that rt2x00soc lib
>> >>>>  which might be another patch)
>> >>>> - and some fixes...
>> >>>
>> >>> Not only that but this driver is not yet merged upstream, there should
>> >>> be a good reason for that.
>> >>>
>> >>> Ivo, what's the status on rt2800pci? Some users have been asking about
>> >>> it.
>> >>
>> >> The status is that it is not functioning correctly, during boot it
>> >> will print out
>> >> tons of errors about the device not being ready, and afterward it cannot
>> >> scan,
>> >> connect or do anything useful.
>> >>
>> >> And I think those problems can be considered enough reasons for not
>> >> merging
>> >> the driver upstream yet. ;)
>> >>
>> >> Ivo
>> >
>> > I would say so. :) Assuming there is a bit of truth in those claims of that
>> > tarball working better than the current kernel code, we might take away all
>> > the new driver bloat and see what remains (which might be the part Ivo has
>> > anyways in wireless testing...)
>>
>> Its not part of wireless-testing.
>
> Well any patches in rt2x00.git which I have not send to linux-wireless yet
> should _not_ be merged to anywhere since they are often incomplete,
> incorrect or plain broken.

Thanks Ivo -- that is what I suspected. Please do not merge wireless
shit into karmic unless upstream. If its really shit then please push
to staging.

  Luis
