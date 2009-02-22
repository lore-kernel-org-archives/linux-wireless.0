Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:56068 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbZBWART (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2009 19:17:19 -0500
Received: by yw-out-2324.google.com with SMTP id 5so709724ywh.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Feb 2009 16:17:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87tz6md748.fsf@litku.valot.fi>
References: <c4d76b3b0902161643p73101b29hb55a9da696d16da9@mail.gmail.com>
	 <8763j7qyfx.fsf@litku.valot.fi> <1235014330.6344.18.camel@rainbow>
	 <87fxibhr5q.fsf@litku.valot.fi>
	 <c4d76b3b0902192007s347ea4e3hcfa3fae1a1e3060b@mail.gmail.com>
	 <87hc2okyrm.fsf@litku.valot.fi>
	 <c4d76b3b0902211344j5cefcdd3p4e34ddc0ac5d78d@mail.gmail.com>
	 <c4d76b3b0902211400t7f5909d1o9ea8325f40db2aff@mail.gmail.com>
	 <87tz6md748.fsf@litku.valot.fi>
Date: Sun, 22 Feb 2009 18:54:42 -0500
Message-ID: <c4d76b3b0902221554h4cec5204xeaf10c28386c658e@mail.gmail.com> (sfid-20090223_011722_949979_89927274)
Subject: Re: [PATCH] at76c50x-usb: support cfg80211 scanning
From: Jason Andryuk <jandryuk@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 22, 2009 at 6:49 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> Jason Andryuk <jandryuk@gmail.com> writes:
>> at76_usb in staging does not compile.
>
> This is in linux-wireless, right? That's because net/ieee80211.h was
> just removed. I'll have a patch ready for at76_usb and I'll send it to
> Greg.

Thanks for making the changes.  Yes, it was with the wireless-testing
git tree.  I did replace net/ieee80211.h with linux/iee80211.h, but I
gave up when compilations errors were still reported.

The good news it, I am writing this email with the staging/at76_usb
driver.  It is working at the same location as the Windows driver was
tested.

I'll start looking into what may have changed.

Thanks again.

Jason
