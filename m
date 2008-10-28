Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f18.google.com ([209.85.217.18]:51093 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbYJ1IRb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 04:17:31 -0400
Received: by gxk11 with SMTP id 11so1182181gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 01:17:30 -0700 (PDT)
Message-ID: <43e72e890810280117t44e4b0b8nbf1a2b68a989d3a2@mail.gmail.com> (sfid-20081028_091734_749712_CCAC7CB1)
Date: Tue, 28 Oct 2008 01:17:29 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: rtl2860 driver in mainline?
Cc: "Thorsten Leemhuis" <fedora@leemhuis.info>,
	"Greg KH" <greg@kroah.com>, rt2400-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org
In-Reply-To: <1225181562.3796.76.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081028004915.GA3442@kroah.com> <4906B944.4010105@leemhuis.info>
	 <1225180598.3796.66.camel@johannes.berg>
	 <43e72e890810280102i3df34e2h9bf281c5d1e00a48@mail.gmail.com>
	 <1225181562.3796.76.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2008 at 1:12 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-10-28 at 01:02 -0700, Luis R. Rodriguez wrote:
>
>> > I don't think it makes sense either, at _best_ it'll do nothing but help
>> > a few users [1], and if somebody actually starts working on the vendor
>> > driver because it's in staging that's actively harmful to the real
>> > driver by diverting resources away from it.
>> >
>> > johannes
>> >
>> > [1] I used to think the point wasn't to make users happy but to make it
>> > easier to work on those drivers, but that objective seems long gone
>>
>> Problem is distributions already ship crap anyway.
>
> Well, yes, but that's fine, it doesn't mean people will work on the
> crap, it means people will use the crap. As far as I understood, putting
> it into staging was supposed to mean "here is some crap for people to
> work on", which is a huge difference.

Well its not staging if it doesn't work as well, if we are going to
stage might as well let it work while there are no alternatives no?

  Luis
