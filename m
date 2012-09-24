Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49994 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757663Ab2IXTAV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2012 15:00:21 -0400
Date: Mon, 24 Sep 2012 14:54:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcma: export PLL reading function
Message-ID: <20120924185442.GE32351@tuxdriver.com> (sfid-20120924_210025_159800_B0E408E6)
References: <1347483216-2309-1-git-send-email-zajec5@gmail.com>
 <CACna6ryBiRQF5Xwjb0ysJ6YFnuSZSb5_st2A8eaL3BJ=b-exqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6ryBiRQF5Xwjb0ysJ6YFnuSZSb5_st2A8eaL3BJ=b-exqA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 21, 2012 at 10:27:51AM +0200, Rafał Miłecki wrote:
> 2012/9/12 Rafał Miłecki <zajec5@gmail.com>:
> > This is required by NAND flash driver for initializing wait counters.
> 
> John: have you take a look at this patch? Can you take it or would you
> prefer it to be submitted together with NAND driver (using different
> than wireless tree)?

I think you should just send it as part of a series with the driver
that makes use of it.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
