Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43729 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab1EJWaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 18:30:11 -0400
Received: by gwaa18 with SMTP id a18so2311273gwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2011 15:30:10 -0700 (PDT)
Message-ID: <4DC9BC6E.2090804@lwfinger.net> (sfid-20110511_003019_963034_0ACC0128)
Date: Tue, 10 May 2011 17:30:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH V2 0/3] ssb/b43(legacy): clean dangling cores workarounds
References: <1304879433-7096-1-git-send-email-zajec5@gmail.com>	<BANLkTimecZ0uB4V_b-8F784Tnbkqo71ORA@mail.gmail.com> <BANLkTinfMbkyh9kB+hsmka-JcWXAYEPynw@mail.gmail.com>
In-Reply-To: <BANLkTinfMbkyh9kB+hsmka-JcWXAYEPynw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2011 05:08 PM, Rafał Miłecki wrote:
> W dniu 8 maja 2011 19:54 użytkownik Rafał Miłecki<zajec5@gmail.com>  napisał:
>> W dniu 8 maja 2011 20:30 użytkownik Rafał Miłecki<zajec5@gmail.com>  napisał:
>>> There is no perfect place for this workarounds, but keeping it in ssb sounds
>>> more reasonable.
>>
>> Uups, I didn't save edition fixing this grammatical mistake. I'm lucky
>> it won't be visible anywhere in git log :)
>
> John: something went wrong there. You applied b43 and b43legacy
> patches, but they should applied *after* ssb patch I don't see in your
> tree.
>
> I don't know how many people can be affected by this... Can not tell
> you if we should rebase or just commit ssb patch quickly.

My BCM4306 card is probably one of the few affected. No rebase will be needed as 
long as the ssb patch is available in 2.6.40-rc1. Fortunately, kernel building 
is not impacted.

Larry
