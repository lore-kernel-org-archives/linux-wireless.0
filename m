Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:23009 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbYJ1IC1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 04:02:27 -0400
Received: by yx-out-2324.google.com with SMTP id 8so606250yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 01:02:26 -0700 (PDT)
Message-ID: <43e72e890810280102i3df34e2h9bf281c5d1e00a48@mail.gmail.com> (sfid-20081028_090233_161573_8644B5F7)
Date: Tue, 28 Oct 2008 01:02:26 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: rtl2860 driver in mainline?
Cc: "Thorsten Leemhuis" <fedora@leemhuis.info>,
	"Greg KH" <greg@kroah.com>, rt2400-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org
In-Reply-To: <1225180598.3796.66.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081028004915.GA3442@kroah.com> <4906B944.4010105@leemhuis.info>
	 <1225180598.3796.66.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2008 at 12:56 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-10-28 at 08:03 +0100, Thorsten Leemhuis wrote:
>> On 28.10.2008 01:49, Greg KH wrote:
>> > So, on my quest to suck up every out-of-tree driver and get it into the
>> > main kernel tree (drivers/staging/ to start with), I've been pointed at
>> > the rtl2860 driver.
>>
>> Does it really make sense to include a driver when a different one for
>> mainline inclusion is being actively developed? It might give some
>> developers the impression that it's worth spending time improving the
>> rtl2860/2870 drivers -- which might be wasted time in the end.
>
> I don't think it makes sense either, at _best_ it'll do nothing but help
> a few users [1], and if somebody actually starts working on the vendor
> driver because it's in staging that's actively harmful to the real
> driver by diverting resources away from it.
>
> johannes
>
> [1] I used to think the point wasn't to make users happy but to make it
> easier to work on those drivers, but that objective seems long gone

Problem is distributions already ship crap anyway.

  Luis
