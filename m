Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34670 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab1ITV0K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 17:26:10 -0400
Received: by ewy4 with SMTP id 4so743737ewy.5
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2011 14:26:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADnq5_OBLpQigLX1zqh5NGyW6crJO3G5xyBEnu+CwVxac-dkYQ@mail.gmail.com>
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
	<20110920130338.GA9885@kroah.com>
	<1316524874.3953.41.camel@jlt3.sipsolutions.net>
	<CACna6rxxoRoLi9C3RBsot8kvZx4k5AZVHzHoE17q-iT1U7i5qg@mail.gmail.com>
	<CADnq5_OBLpQigLX1zqh5NGyW6crJO3G5xyBEnu+CwVxac-dkYQ@mail.gmail.com>
Date: Tue, 20 Sep 2011 23:23:38 +0200
Message-ID: <CACna6rw4s31B9tv3sogdXGbW=5n-GXJFOPBHhQkLyQBCGdXdsQ@mail.gmail.com> (sfid-20110920_232615_113634_4FBCB424)
Subject: Re: [PATCH 00/20] staging: brcm80211: 7th reaction for mainline patch #2
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, gregkh@suse.de,
	linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 20 września 2011 23:12 użytkownik Alex Deucher
<alexdeucher@gmail.com> napisał:
> 2011/9/20 Rafał Miłecki <zajec5@gmail.com>:
>> 2011/9/20 Johannes Berg <johannes@sipsolutions.net>:
>>> On Tue, 2011-09-20 at 06:03 -0700, Greg KH wrote:
>>>
>>>> And while code is great and nice, I still haven't seen any real answers
>>>> to all of the questions that were asked of the Broadcom driver team
>>>> during that review by the linux-wireless developers about how things
>>>> will be handled properly due to the overlap in functionality with the
>>>> existing "real" driver in the tree.
>>>
>>> Let's qualify this to "some developers".
>>>
>>> One thing I'd like to point out is that the Broadcom's firmware API has
>>> always undergone changes over time. I'm actually surprised that b43
>>> works as well as it does (which, tbh, isn't very well at all, at least
>>> for me with some 11n PHY). I also don't think that Broadcom are going to
>>> maintain compatibility and/or maintain new firmware features for old
>>> devices, that just doesn't make any sense.
>>
>> Actually, when we got some single response from Broadcom about their
>> relation to b43, they haven't mentioned support for old HW is any
>> problem at all.
>
> If you look at it from the perspective of a hardware manufacturer,
> supporting EOLed chips is generally not a good return on investment.
> There is no new revenue associated with them so any work that goes
> into them stands to return very little.

That's another thing to discuss with Broadcom.

In open source kernel world, we hopefully won't let anyone drop
support for older hardware, just because it's not produced anymore.
Probably something like forking driver or modularizing it makes more
sense to us.

On the other hand we don't want Broadcom to support b43 and all the
PHYs it covers. We've already mentioned they could decide to support
b43 but limit their official support to selected cards only. They
(again) didn't response how they see such an idea.

What we really need is some communication with Broadcom and I guess
that's what Greg mostly wanted to achieve.

-- 
Rafał
