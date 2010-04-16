Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:59206 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758191Ab0DPPvT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 11:51:19 -0400
Received: by wwb24 with SMTP id 24so1255178wwb.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Apr 2010 08:51:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100416133711.GB8554@tuxdriver.com>
References: <p2ub170af451004152320y64c4615ub3d7186d936cdc62@mail.gmail.com>
	 <20100416133711.GB8554@tuxdriver.com>
Date: Fri, 16 Apr 2010 17:51:17 +0200
Message-ID: <m2wb170af451004160851veaed6df6r2e8ec0528f66685e@mail.gmail.com>
Subject: Re: [PATCH PING] ssb patches for SPROM location
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 16 kwietnia 2010 15:37 użytkownik John W. Linville
<linville@tuxdriver.com> napisał:
> On Fri, Apr 16, 2010 at 08:20:51AM +0200, Rafał Miłecki wrote:
>> John, I posted some time ago following patches:
>>
>> [RFT][PATCH] ssb: Look for SPROM at different offset on higher rev CC
>> [PATCH 1/2] ssb: Use relative offsets for SPROM
>> [PATCH 2/2] ssb: Fix order of definitions and some text space indents
>>
>> while Michael has some doubts about "ssb: Look for SPROM at different
>> offset on higher rev CC" I explained to him that what he does not like
>> was fixed in next 2 posted patches.
>>
>> AFAIR you got some device with this recently-discovered location of
>> SPROM. Could you test my set if it makes your card working? If so,
>> could you take that patches to your tree?
>
> Sorry, been busy w/ other things.  FWIW, my implementation based on
> the RE work from Larry did not work on the box in question, and my
> implementation wasn't substantially different from yours.  Anyway,
> I'll try to confirm this soon w/ your patches and to collect more
> information for Larry.

Ah, I didn't know you got own implementation. Had to miss it.

Larry do you have any ideas what else may we do incorrectly?

John: may be worth checking if your card matched this new condition
and if driver actually used "new" offset.

-- 
Rafał
