Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63714 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab2IXT6H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2012 15:58:07 -0400
Received: by wgbdr13 with SMTP id dr13so4012649wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2012 12:58:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120924185442.GE32351@tuxdriver.com>
References: <1347483216-2309-1-git-send-email-zajec5@gmail.com>
	<CACna6ryBiRQF5Xwjb0ysJ6YFnuSZSb5_st2A8eaL3BJ=b-exqA@mail.gmail.com>
	<20120924185442.GE32351@tuxdriver.com>
Date: Mon, 24 Sep 2012 21:58:06 +0200
Message-ID: <CACna6ryoWPYrdn4mAPf_APw-wSoceHPnaYGDOnOPGyR--cF5kw@mail.gmail.com> (sfid-20120924_215812_708718_615883FD)
Subject: Re: [PATCH] bcma: export PLL reading function
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/9/24 John W. Linville <linville@tuxdriver.com>:
> On Fri, Sep 21, 2012 at 10:27:51AM +0200, Rafał Miłecki wrote:
>> 2012/9/12 Rafał Miłecki <zajec5@gmail.com>:
>> > This is required by NAND flash driver for initializing wait counters.
>>
>> John: have you take a look at this patch? Can you take it or would you
>> prefer it to be submitted together with NAND driver (using different
>> than wireless tree)?
>
> I think you should just send it as part of a series with the driver
> that makes use of it.

OK, drop it :)

-- 
Rafał
