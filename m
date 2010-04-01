Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38289 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab0DARLr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 13:11:47 -0400
Received: by wyb39 with SMTP id 39so620940wyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Apr 2010 10:11:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201004011736.50440.mb@bu3sch.de>
References: <1270065561-4333-1-git-send-email-zajec5@gmail.com>
	 <201004011736.50440.mb@bu3sch.de>
Date: Thu, 1 Apr 2010 19:11:45 +0200
Message-ID: <l2tb170af451004011011nb230421cmfb5bcb3ac516eb7c@mail.gmail.com>
Subject: Re: [RFT][PATCH] ssb: Look for SPROM at different offset on higher
	rev CC
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/4/1 Michael Buesch <mb@bu3sch.de>:
> On Wednesday 31 March 2010 21:59:21 Rafał Miłecki wrote:
>> Our offset handling becomes even a little more hackish now. For some reason I
>> do not understand all offsets as inrelative. It assumes base offset is 0x1000
>> but it will work for now as we make offsets relative anyway by removing base
>> 0x1000. Should be cleaner however.
>>
>
> What about fixing it correctly instead adding a hack?

See next 2 patches :)

I believe it does not add any hackish code, just exposes weirdness of
current code to bigger degree. Anyway as I said, I fixed this in next
patch I sent already yesterday.

-- 
Rafał
