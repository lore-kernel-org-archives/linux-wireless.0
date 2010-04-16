Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f196.google.com ([209.85.221.196]:48074 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758049Ab0DPQWd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 12:22:33 -0400
Received: by qyk34 with SMTP id 34so3483340qyk.22
        for <linux-wireless@vger.kernel.org>; Fri, 16 Apr 2010 09:22:32 -0700 (PDT)
Message-ID: <4BC88EC4.5000606@lwfinger.net>
Date: Fri, 16 Apr 2010 11:22:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH PING] ssb patches for SPROM location
References: <p2ub170af451004152320y64c4615ub3d7186d936cdc62@mail.gmail.com>	 <20100416133711.GB8554@tuxdriver.com> <m2wb170af451004160851veaed6df6r2e8ec0528f66685e@mail.gmail.com>
In-Reply-To: <m2wb170af451004160851veaed6df6r2e8ec0528f66685e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2010 10:51 AM, Rafał Miłecki wrote:
> W dniu 16 kwietnia 2010 15:37 użytkownik John W. Linville
> <linville@tuxdriver.com> napisał:
>> On Fri, Apr 16, 2010 at 08:20:51AM +0200, Rafał Miłecki wrote:
>>> John, I posted some time ago following patches:
>>>
>>> [RFT][PATCH] ssb: Look for SPROM at different offset on higher rev CC
>>> [PATCH 1/2] ssb: Use relative offsets for SPROM
>>> [PATCH 2/2] ssb: Fix order of definitions and some text space indents
>>>
>>> while Michael has some doubts about "ssb: Look for SPROM at different
>>> offset on higher rev CC" I explained to him that what he does not like
>>> was fixed in next 2 posted patches.
>>>
>>> AFAIR you got some device with this recently-discovered location of
>>> SPROM. Could you test my set if it makes your card working? If so,
>>> could you take that patches to your tree?
>>
>> Sorry, been busy w/ other things.  FWIW, my implementation based on
>> the RE work from Larry did not work on the box in question, and my
>> implementation wasn't substantially different from yours.  Anyway,
>> I'll try to confirm this soon w/ your patches and to collect more
>> information for Larry.
> 
> Ah, I didn't know you got own implementation. Had to miss it.
> 
> Larry do you have any ideas what else may we do incorrectly?

No. AFAICT, we have implemented it correctly. Any additional info would
be welcome.

Larry
