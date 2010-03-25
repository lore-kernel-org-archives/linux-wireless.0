Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48979 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab0CYWoC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 18:44:02 -0400
Received: by vws8 with SMTP id 8so1039819vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Mar 2010 15:44:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100325222400.GA7547@spartakus>
References: <4B5CD1FF.4090209@twilightblue.net>
	 <loom.20100321T212710-762@post.gmane.org>
	 <b6c5339f1003251402sa2faff0m42e1a7fef7356e13@mail.gmail.com>
	 <b6c5339f1003251404p624d7f15mae54813453821b33@mail.gmail.com>
	 <20100325222400.GA7547@spartakus>
Date: Thu, 25 Mar 2010 18:44:01 -0400
Message-ID: <b6c5339f1003251544r35b59c8fqf6a9beeaa3264b82@mail.gmail.com>
Subject: Re: Bug: 2.6.32 ath5k, associating with WEP128 AP is unreliable
From: Bob Copeland <me@bobcopeland.com>
To: nanokk@gmx.net
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 25, 2010 at 6:24 PM, nanok <rnanok@gmail.com> wrote:
> On Thu, Mar 25, 2010 at 05:04:02PM -0400, Bob Copeland wrote:
>> On Thu, Mar 25, 2010 at 5:02 PM, Bob Copeland <me@bobcopeland.com> wrote:
>>
>> > As you are using debian I have to ask: have you installed
>> > crda? ?Since 2.6.30 ath5k gained regulatory support which
>> > may cause certain channels to be disabled.
>>
>> By "since 2.6.30" I meant post-2.6.30, sorry for any
>> confusion.
>>
>> --
>> Bob Copeland %% www.bobcopeland.com
>>
>
> hi Bob,
>
> no confusion, it's perfectly clear either way you state it.
> unfortunately, it's 2.6.3
> 0 that "works" (not pre-2.6.30), or did you mean since 2.6.30, excluding
> 2.6.30?

Right, that is what I tried to correct.  _After_ 2.6.30,
ath5k began reporting the regdomain from the EEPROM which
means some channels (13 is a common case) are no longer
accessible whereas they were before with static reg domains
and no EEPROM support.  That was the major change in the
driver.  Most other changes since 2.6.30 were in the
upper-layers.  I don't recall any changes to crypto in that
timeframe.

WRT to the original report, is only WEP causing problems
(i.e. does WPA work?)

-- 
Bob Copeland %% www.bobcopeland.com
