Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:37103 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab0LDVhi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Dec 2010 16:37:38 -0500
Received: by wwe15 with SMTP id 15so2413103wwe.1
        for <linux-wireless@vger.kernel.org>; Sat, 04 Dec 2010 13:37:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=iixqOgRhgGwwuz+oVzO78yXZ7C=Y8uX+3M_VZ@mail.gmail.com>
References: <20101203040300.GA2988@makis.mantri>
	<20101203145558.GA2348@tuxdriver.com>
	<AANLkTi=iixqOgRhgGwwuz+oVzO78yXZ7C=Y8uX+3M_VZ@mail.gmail.com>
Date: Sat, 4 Dec 2010 23:37:36 +0200
Message-ID: <AANLkTi=K27-D-4QQe4DYmPDvWnYW1WK48OA+U2C9t5sN@mail.gmail.com>
Subject: Re: [PATCH 1/6] ath5k: Always write tx powertable on hw
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	mcgrof@gmail.com, jirislaby@gmail.com, nbd@openwrt.org,
	br1@einfach.org, sedat.dilek@googlemail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/12/4 Bob Copeland <me@bobcopeland.com>:
> On Fri, Dec 3, 2010 at 9:55 AM, John W. Linville <linville@tuxdriver.com> wrote:
>> On Fri, Dec 03, 2010 at 06:03:00AM +0200, Nick Kossifidis wrote:
>>>  * By skipping tx power table calibration we also skip setting
>>>  tx power table on hw. Make sure we always write tx power table
>>>  on hw since it gets cleared on reset.
>>>
>>>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>>
>> Hey, Nick -- just a process note...
>>
>> All your patches have " Signed-off-by..." (notice the leading space),
>> which looks a bit funny.  Could you figure-out why this is happening
>> and change it to remove the leading space?
>
> Also the "*" thing is a bit weird as kernel commit messages go.
>

Sorry, bad habits, will change that next time ;-)


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
