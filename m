Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55244 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab1CUOw6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 10:52:58 -0400
Received: by qyk7 with SMTP id 7so2494397qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 07:52:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110321144603.GA7645@kroah.com>
References: <20110319234524.GA7493@kroah.com>
	<op.vsmyhmei3ri7v4@arend-laptop>
	<20110320145421.GA13962@kroah.com>
	<op.vsnd1a1i3ri7v4@arend-laptop>
	<20110320162200.GA17030@kroah.com>
	<op.vsng7q1j3ri7v4@arend-laptop>
	<20110320185216.GD19375@kroah.com>
	<AANLkTimEGR-8zhbMQpcAzYkuZ8fHkhj1bOQrb3rShfsP@mail.gmail.com>
	<20110321140505.GA7321@kroah.com>
	<AANLkTi=1eGo7uvP8Uy32yQezhGJTHYkHpEyX9vF=PujF@mail.gmail.com>
	<20110321144603.GA7645@kroah.com>
Date: Mon, 21 Mar 2011 15:52:56 +0100
Message-ID: <AANLkTi=f_Gn7+4ahnZFwOw9qWUV05+WpjaRkajaYGxky@mail.gmail.com>
Subject: Re: new utility kernel module for detecting cores in newer chipsets
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	John Linville <linville@tuxdriver.com>,
	George Kashperko <george@znau.edu.ua>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/3/21 Greg KH <greg@kroah.com>:
> In digging through my archives, yes I did.
>
> But the proper thing to do is to quote portions in which you refer to
> when talking about them.  Otherwise the reciever can easily be lost.
>
> Remember, some of us get _thousands_ of emails a day.  Remembering
> context based on a subject: line is impossible, especially when the
> thread is long gone from my inbox and buried in my archive.

Right, sorry for that.


>> The case is, we discussed ssb/ai driver layout few days ago. George
>> shared idea of layout I agree with, nobody shared any objections. If
>> everything goes fine, we should have nicely modularized driver/project
>> supporting Broadcom's buses.
>>
>> In this situation I'm not really interested is simple ai driver
>> stripped from brcm80211. According to me, it would led to harder
>> maintenance and harder implementation of support for such a driver in
>> b43.
>
> Ok, and I trust that you and Michael will work things out.
>
> I have no objections to what you want at all, why do you think I do?
> I'm just handling getting the stuff in drivers/staging/ out of there,
> that's it.  I trust the rest of you all to handle the design decisions
> properly.
>
> And as there is no code here yet to complain about, I fail to see any
> problem yet :)

It was not directly to you, I believe you already many things to worry
about, and are not really interested in getting into another driver
layout :)

I expected Michael and Arend to talk with us (mostly me and George)
about current situation.

-- 
Rafał
