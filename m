Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47330 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765702AbYESXYm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 19:24:42 -0400
Date: Tue, 20 May 2008 02:22:37 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [2.6 patch] strip: remove dead URL
Message-ID: <20080519232237.GF17716@cs181133002.pp.htv.fi> (sfid-20080520_012510_392517_54290071)
References: <20080519221006.GZ17716@cs181133002.pp.htv.fi> <1211235365.6252.68.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1211235365.6252.68.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2008 at 12:16:05AM +0200, Johannes Berg wrote:
> On Tue, 2008-05-20 at 01:10 +0300, Adrian Bunk wrote:
> > http://mosquitonet.Stanford.EDU/strip.html no longer exists.
> 
> Out of curiosity, does anybody even have this hardware? Does it even
> exist still? I mean, cell-phone sized 100kbit/sec wireless hardware? Who
> would use that? :)

And don't forget that this "about the size and weight of a cellular 
telephone" was written back in 1996...

I was very near at suggesting removal of this driver, but at least
five years ago someone tried to use it (without success). [1]

But if the general opinion is it should be removed I'd be glad to send
a patch.

> johannes

cu
Adrian

[1] http://lkml.org/lkml/2003/2/26/177

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

