Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:17894 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbYGaRFa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 13:05:30 -0400
Received: by an-out-0708.google.com with SMTP id d40so103005and.103
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jul 2008 10:05:29 -0700 (PDT)
Message-ID: <43e72e890807311005l3fd7823ej68497586ec9ff6bc@mail.gmail.com> (sfid-20080731_190533_721507_B54661D9)
Date: Thu, 31 Jul 2008 10:05:29 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Vendor support stickers for devices supported under Linux wireless
Cc: drago01 <drago01@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1217498887.10489.138.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890807301327j54be2453r836964c708d75458@mail.gmail.com>
	 <f6ca9fed0807301357k3c096c37q906ecd68a0219f7f@mail.gmail.com>
	 <43e72e890807301358r6d8cadc1j4f40b501319fb7dc@mail.gmail.com>
	 <1217498887.10489.138.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 31, 2008 at 3:08 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-07-30 at 13:58 -0700, Luis R. Rodriguez wrote:
>> >> We could even put the name of the driver on
>> >> the sticker/logo. Thoughts?
>> >
>> > I would rather do s/driver name/kernel version/ ... its easier for
>> > users that way.
>>
>> True, do you mean since a specific kernel version?
>
> Down that road lies madness. Distros backport, you (in compat) backport,
> kernel versions sound old very quickly and in a year, when linux is
> called 2.9.06 you may not even want to sell a card that says "2.6.25" on
> it because it sounds ancient.
>
> Just leave it out, make it depend on the driver being merged into
> Linus's tree, leave it up to the distros to actually ship the code.

Make sense.

> I would also add to the contract a requirement to offer Linux support
> for, say, the next five years.

Not sure if we should call it a contract unless its understood its an
informal contract with the community. Also I don't think we should be
specific about a time frame for support -- its difficult enough to get
the driver upstream, not that its not possible I just think it we
should strive to at least get vendors to properly support Linux by
submitting their drivers for upstream into Linus' tree. Support tends
to come naturally after that :)

http://linuxwireless.org/download/images/in-linux-green.png

Hm?

  Luis
