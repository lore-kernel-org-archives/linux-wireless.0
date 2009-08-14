Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:35238 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbZHNSMJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 14:12:09 -0400
Received: by fxm11 with SMTP id 11so1316077fxm.39
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 11:12:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250273426.4411.0.camel@johannes.local>
References: <43e72e890908131331q371320a3gf1ab53ea27574549@mail.gmail.com>
	<4A859F52.1000608@gmail.com> <1250273426.4411.0.camel@johannes.local>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 14 Aug 2009 20:11:49 +0200
Message-ID: <69e28c910908141111g171c1a23qc2d49992468ddf44@mail.gmail.com>
Subject: Re: Spare warnings - wireless drivers
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dave <kilroyd@googlemail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 14, 2009 at 8:10 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Fri, 2009-08-14 at 18:30 +0100, Dave wrote:
>
>> I've been staring at setibssport for 5 minutes, and can't see the
>> alleged imbalance. False positive?
>>
>> I can't see why sparse picked on setibssport either - half the other
>> functions in that file do exactly the same.
>
> Yeah, I've been there too -- no idea why that particular function trips
> up sparse.
>
> johannes
>

It's literally a sparse warning, then.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
