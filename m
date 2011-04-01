Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44432 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab1DAQVt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 12:21:49 -0400
Received: by ewy4 with SMTP id 4so1106282ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 09:21:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1301674530.5219.25.camel@maggie>
References: <AANLkTikGp+ZFhTtsaW7E4SO_5trte1_eF4KLWbkwVty5@mail.gmail.com>
	<1301673646.5219.18.camel@maggie>
	<BANLkTin2ZaBVbum9Y=iqWTwW4kzkdKAJnA@mail.gmail.com>
	<1301674530.5219.25.camel@maggie>
Date: Fri, 1 Apr 2011 18:21:47 +0200
Message-ID: <BANLkTikR3DjQ1LbU47zrm+zV3sqW37bzrA@mail.gmail.com>
Subject: Re: ChipCommon as independent driver?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 1 kwietnia 2011 18:15 użytkownik Michael Büsch <mb@bu3sch.de> napisał:
> On Fri, 2011-04-01 at 18:06 +0200, Rafał Miłecki wrote:
>> W dniu 1 kwietnia 2011 18:00 użytkownik Michael Büsch <mb@bu3sch.de> napisał:
>> > On Fri, 2011-04-01 at 16:49 +0200, Rafał Miłecki wrote:
>> >> Do you have idea how we could nicely solve that issue?
>> >
>> > Yeah. Just don't share code between ssb and bcmai.
>> > That's the only clean solution to that mess.
>>
>> Do you want to have core drivers separated as well? Really? Should we
>> have separated pci core? chiccommon core?
>
> Yes. Those "drivers" are a mess full of ssb specific workarounds
> to hardware limitations.

I really don't understand what you meant in:

2011/2/18 Michael Büsch <mb@bu3sch.de>:
> Note that this does not mean that we need to duplicate the MIPS,
> common and probably pci core drivers. A hybrid module can be done,
> if that's desired to avoid code duplication.

then :|

-- 
Rafał
