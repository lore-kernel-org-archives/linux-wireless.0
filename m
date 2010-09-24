Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61722 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab0IXTnH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 15:43:07 -0400
Subject: Re: [PATCH v3] omap: beagle: add support for wl1271 on the board file
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <20100924191139.GI4211@atomide.com>
Date: Fri, 24 Sep 2010 21:42:58 +0200
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	"ext John W. Linville" <linville@tuxdriver.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Message-Id: <8004B807-6120-41C0-979B-214BFB75E5CA@dominion.thruhere.net>
References: <1285236215-21136-1-git-send-email-luciano.coelho@nokia.com> <20100924180316.GE8077@tuxdriver.com> <1285354249.9779.3.camel@powerslave> <20100924191139.GI4211@atomide.com>
To: Tony Lindgren <tony@atomide.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Op 24 sep 2010, om 21:11 heeft Tony Lindgren het volgende geschreven:

> * Luciano Coelho <luciano.coelho@nokia.com> [100924 11:42]:
>> On Fri, 2010-09-24 at 20:03 +0200, ext John W. Linville wrote:
>>> On Thu, Sep 23, 2010 at 01:03:35PM +0300, Luciano Coelho wrote:
>>>> Add board configuration for the wl1271 daughter board.  This patch is based
>>>> on Ohad Ben-Cohen's patches for Zoom boards.
>>>> 
>>>> Cc: Ohad Ben-Cohen <ohad@wizery.com>
>>>> Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
>>>> ---
>>>> from v2 to v3: removed accidental change to wl1271.h
>>> 
>>> I presume that this should come through my tree as well (since it
>>> contains the move of wl12xx.h)?
>> 
>> Yes, this is based on your tree.  But please hold on, because there were
>> some comments (namely, the expansion board should be detected, not
>> configured for wl1271 by default), which I still have to fix.  I'm
>> waiting for the manufacturer of the expansion board to provide me with
>> some more info for proper detection.
>> 
>> Also, I know that there are some other work being done in the beagle
>> board file, so we may need to rethink how to sync this.
>> 
>> So, for now, let's skip this patch and I'll provide another one when
>> these issues are addressed.
> 
> You could also do it based on some kernel cmdline option. Of course
> detection during the runtime would be better.

That's what we're currently doing in the beagle kernels: http://gitorious.org/beagleboard-validation/linux/commit/17c1b214b918c6f9efc5579134a7ff71d51b60bf

That needs forward porting to .37 before I can submit is as RFC here :)