Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f18.google.com ([209.85.217.18]:47940 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbYJ1IBX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 04:01:23 -0400
Received: by gxk11 with SMTP id 11so1174165gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 01:01:22 -0700 (PDT)
Message-ID: <43e72e890810280101v23839ffcka38397a291247668@mail.gmail.com> (sfid-20081028_090128_646407_FFCE1F96)
Date: Tue, 28 Oct 2008 01:01:22 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Luis Correia" <luis.f.correia@gmail.com>
Subject: Re: rtl2860 driver in mainline?
Cc: "Thorsten Leemhuis" <fedora@leemhuis.info>,
	"Greg KH" <greg@kroah.com>, rt2400-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org
In-Reply-To: <efe7343f0810280048j57158020n67176d7a56f0bbea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081028004915.GA3442@kroah.com> <4906B944.4010105@leemhuis.info>
	 <efe7343f0810280048j57158020n67176d7a56f0bbea@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2008 at 12:48 AM, Luis Correia <luis.f.correia@gmail.com> wrote:
> Hi!
>
> On Tue, Oct 28, 2008 at 07:03, Thorsten Leemhuis <fedora@leemhuis.info> wrote:
>> On 28.10.2008 01:49, Greg KH wrote:
>>>
>>> So, on my quest to suck up every out-of-tree driver and get it into the
>>> main kernel tree (drivers/staging/ to start with), I've been pointed at
>>> the rtl2860 driver.
>>
>> Does it really make sense to include a driver when a different one for
>> mainline inclusion is being actively developed? It might give some
>> developers the impression that it's worth spending time improving the
>> rtl2860/2870 drivers -- which might be wasted time in the end.
>
> Is it just me or you are suggesting we use the Ralink supplied driver,
> with its own wireless stack, rather then work with the rt2x00 team?
>
> Do we really want that again (several wireless stacks)?

Staging means temporary, a place for you to stash crap, which
ultimately and hopefully will unbecome crap and some sort of butterfly
will come out. Now I got poetic.

  Luis
