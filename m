Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:1396 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbYJ1IGl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 04:06:41 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2572502rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 01:06:40 -0700 (PDT)
Message-ID: <efe7343f0810280106k681f05fdh62a00f666926286a@mail.gmail.com> (sfid-20081028_090712_481846_77B0C097)
Date: Tue, 28 Oct 2008 08:06:39 +0000
From: "Luis Correia" <luis.f.correia@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: rtl2860 driver in mainline?
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Thorsten Leemhuis" <fedora@leemhuis.info>,
	"Greg KH" <greg@kroah.com>, rt2400-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890810280102i3df34e2h9bf281c5d1e00a48@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081028004915.GA3442@kroah.com> <4906B944.4010105@leemhuis.info>
	 <1225180598.3796.66.camel@johannes.berg>
	 <43e72e890810280102i3df34e2h9bf281c5d1e00a48@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Tue, Oct 28, 2008 at 08:02, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Tue, Oct 28, 2008 at 12:56 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Tue, 2008-10-28 at 08:03 +0100, Thorsten Leemhuis wrote:
>>> On 28.10.2008 01:49, Greg KH wrote:
>>> > So, on my quest to suck up every out-of-tree driver and get it into the
>>> > main kernel tree (drivers/staging/ to start with), I've been pointed at
>>> > the rtl2860 driver.
>>>
>>> Does it really make sense to include a driver when a different one for
>>> mainline inclusion is being actively developed? It might give some
>>> developers the impression that it's worth spending time improving the
>>> rtl2860/2870 drivers -- which might be wasted time in the end.
>>
>> I don't think it makes sense either, at _best_ it'll do nothing but help
>> a few users [1], and if somebody actually starts working on the vendor
>> driver because it's in staging that's actively harmful to the real
>> driver by diverting resources away from it.
>>
>> johannes
>>
>> [1] I used to think the point wasn't to make users happy but to make it
>> easier to work on those drivers, but that objective seems long gone
>
> Problem is distributions already ship crap anyway.

Exactly, last April I realised that Caixa Magica (the Portuguese
Mandriva spinoff) already had two drivers for Ralink chipsets, being
that it even had wrong usb ID's in the code. (a rtl8187 was identified
as rt72usb..)

>
>  Luis
> --

Luis
