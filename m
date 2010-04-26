Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:50858 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab0DZSdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 14:33:32 -0400
Received: by wwb22 with SMTP id 22so662502wwb.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Apr 2010 11:33:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100426182655.GE2387@tuxdriver.com>
References: <p2ub170af451004152320y64c4615ub3d7186d936cdc62@mail.gmail.com>
	 <20100416133711.GB8554@tuxdriver.com>
	 <m2wb170af451004160851veaed6df6r2e8ec0528f66685e@mail.gmail.com>
	 <4BC88EC4.5000606@lwfinger.net> <20100426182655.GE2387@tuxdriver.com>
Date: Mon, 26 Apr 2010 20:33:29 +0200
Message-ID: <y2nb170af451004261133qe1e0dfaand43c190b6f7f8d3@mail.gmail.com>
Subject: Re: [PATCH PING] ssb patches for SPROM location
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/4/26 John W. Linville <linville@tuxdriver.com>:
> On Fri, Apr 16, 2010 at 11:22:28AM -0500, Larry Finger wrote:
>> On 04/16/2010 10:51 AM, Rafał Miłecki wrote:
>> > W dniu 16 kwietnia 2010 15:37 użytkownik John W. Linville
>> > <linville@tuxdriver.com> napisał:
>> >> On Fri, Apr 16, 2010 at 08:20:51AM +0200, Rafał Miłecki wrote:
>> >>> John, I posted some time ago following patches:
>> >>>
>> >>> [RFT][PATCH] ssb: Look for SPROM at different offset on higher rev CC
>> >>> [PATCH 1/2] ssb: Use relative offsets for SPROM
>> >>> [PATCH 2/2] ssb: Fix order of definitions and some text space indents
>> >>>
>> >>> while Michael has some doubts about "ssb: Look for SPROM at different
>> >>> offset on higher rev CC" I explained to him that what he does not like
>> >>> was fixed in next 2 posted patches.
>> >>>
>> >>> AFAIR you got some device with this recently-discovered location of
>> >>> SPROM. Could you test my set if it makes your card working? If so,
>> >>> could you take that patches to your tree?
>> >>
>> >> Sorry, been busy w/ other things.  FWIW, my implementation based on
>> >> the RE work from Larry did not work on the box in question, and my
>> >> implementation wasn't substantially different from yours.  Anyway,
>> >> I'll try to confirm this soon w/ your patches and to collect more
>> >> information for Larry.
>> >
>> > Ah, I didn't know you got own implementation. Had to miss it.
>> >
>> > Larry do you have any ideas what else may we do incorrectly?
>>
>> No. AFAICT, we have implemented it correctly. Any additional info would
>> be welcome.
>
> FWIW, this patch series also still results in a hang on my problematic
> netbook.  I'm going to merge them anyway, in hopes that they make
> things better for someone (or at least get us closer to it).  I'll try
> to pinpoint this hang as well.

Did it actually pick another (newly discovered) offset for SPROM
location in your case? Could you add some single printk to check this?

-- 
Rafał
