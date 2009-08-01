Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:48851 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbZHAIbV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 04:31:21 -0400
Received: by ewy10 with SMTP id 10so1990544ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2009 01:31:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249115316.2007.0.camel@johannes.local>
References: <20090731181020.GE7963@makis> <20090801054649.GA8390@makis>
	 <4A73FA8D.5030804@gmail.com>
	 <1249114918.26584.18.camel@johannes.local>
	 <4A73FBBD.3070507@gmail.com> <1249115316.2007.0.camel@johannes.local>
Date: Sat, 1 Aug 2009 11:31:20 +0300
Message-ID: <40f31dec0908010131q678f03d2x4ba7b6d5d1b51ff5@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 4/4] ath5k: Use SWI to trigger calibration
From: Nick Kossifidis <mickflemm@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/1 Johannes Berg <johannes@sipsolutions.net>:
> On Sat, 2009-08-01 at 10:24 +0200, Jiri Slaby wrote:
>> On 08/01/2009 10:21 AM, Johannes Berg wrote:
>> > Actually, jiffies are unsigned long
>>
>> Yeah, this is what I meant. I agree I messed it up when I didn't write
>> the unsigned explicitly. It might have been confusing, thanks for
>> pointing out.
>
> And, in addition to what you said, the code shouldn't divide jiffies, it
> should multiply the timeout, add it to the start time, and then use
> time_is_after_jiffies() or so.
>
> johannes
>

Where can i find documentation on this ?



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
