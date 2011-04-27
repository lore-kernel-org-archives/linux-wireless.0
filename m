Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45940 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab1D0Uwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 16:52:38 -0400
Received: by qyk7 with SMTP id 7so1988235qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Apr 2011 13:52:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1303936862.7373.5.camel@Nokia-N900>
References: <1303918811-4949-1-git-send-email-zajec5@gmail.com>
	<1303936862.7373.5.camel@Nokia-N900>
Date: Wed, 27 Apr 2011 22:52:37 +0200
Message-ID: <BANLkTikJj4vA6obyCkqwsiG+Ha7aOnz=SQ@mail.gmail.com> (sfid-20110427_225241_899878_72D20FE1)
Subject: Re: [PATCH] ssb: cc: prepare clockmode support for cores rev 10+
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/4/27 Michael Büsch <m@bues.ch>:
>> +            /* udelay(150); TODO: not available in early init */
>
> udelay() should be available at this point. Are you confusing it with
> msleep(), which is not available that early?

I had no idea about this difference, thanks.

However I still think about initializing ChipCommon later, to let it
*sleep* and no to delay boot process. Should this be fine? Or are
there some important reasons to init ChipCommon early?

-- 
Rafał
