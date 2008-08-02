Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:44441 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760705AbYHBTd1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 15:33:27 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2243999wfd.4
        for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 12:33:26 -0700 (PDT)
Message-ID: <40f31dec0808021233s249aa5f2r845b5beb33c72177@mail.gmail.com> (sfid-20080802_213335_876548_059AF186)
Date: Sat, 2 Aug 2008 22:33:26 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath5k-devel] [PATCH 1/12] ath5k: Update register list
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, mcgrof@gmail.com
In-Reply-To: <40f31dec0807311151m13bc2c5ah65b477d2d0ae3fd1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080720033041.GA7440@makis>
	 <20080729204054.GA10188@tuxdriver.com>
	 <40f31dec0807311151m13bc2c5ah65b477d2d0ae3fd1@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/7/31 Nick Kossifidis <mickflemm@gmail.com>:
> 2008/7/29 John W. Linville <linville@tuxdriver.com>:
>> On Sun, Jul 20, 2008 at 06:30:41AM +0300, Nick Kossifidis wrote:
>>>  * Update list of registers
>>>  * Use updated register macros inside hw.c and initvals.c
>>>
>>>  Changes-licensed-under: ISC
>>>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>>
>> Nick,
>>
>> Some of the changes in this patch break the build unless the rest
>> of the series is applied, and those patches can't be applied before
>> applying this one.  This breaks git-bisect.  Could I trouble you
>> to include the pieces of this patch that break the build into those
>> later patches that fix the build?  Or perhaps you can simply split
>> this into a patch that adds new definitions and one that deletes
>> older definitions?  The latter could then be applied at the end of
>> the series.
>>
>> Thanks,
>>
>> John
>
> Hello John ;-)
>
> Now that i resent the 1st patch that was broken can you please commit
> the series ? We really need to add RF2425 support in kernel, it'll
> also help me work easier on ath5k (i won't have to work on top of
> those patches).
>
> All other patches should be O.K.
>

Thanx a lot ;-)



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
