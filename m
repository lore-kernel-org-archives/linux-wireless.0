Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3083 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757997AbXGXQqW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2007 12:46:22 -0400
Date: Tue, 24 Jul 2007 12:12:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Axj <axjslack@bluebottle.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: Request for help...
Message-ID: <20070724161226.GA24344@tuxdriver.com>
References: <1185289332.46a61474a444c@mail.bluebottle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1185289332.46a61474a444c@mail.bluebottle.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since Intel continues to develop their mac80211 fork
on their own, you will have to seek support from them at
ipw3945-devel@lists.sourceforge.net.

I keep hearing that Intel intends to come back to working with the
community on mac80211.  Alas, that has yet to happen.  I want to
believe that it will soon...?

John

On Tue, Jul 24, 2007 at 08:02:12AM -0700, Axj wrote:
> Hi, I'm alex....
> 
> I have a notebook Acer Aspire 5920G, with an intel 4965 wireless, system is a Slackware 12 and kernel is my personal recompiled version of 2.6.21.5. 
> 
> Usually I use the drivers of the version 0.0.* with macsubsystem version 8.0.2, but I've tried to compile the version 0.1.2... a lot of compilation problem. So I think to use  mac9.0.2..... 
> after the make modules of these it's arrived this message.... 
> 
> 
> net/mac80211/wme.c: In function 'ieee80211_ht_agg_queue_add':
> net/mac80211/wme.c:759: error: dereferencing pointer to incomplete type
> net/mac80211/wme.c: In function 'ieee80211_ht_agg_queue_remove':
> net/mac80211/wme.c:784: error: dereferencing pointer to incomplete type
> make[2]: *** [net/mac80211/wme.o] Error 1
> make[1]: *** [net/mac80211] Error 2
> make: *** [net] Error 2
> 
> 
> so I can't compile the new version, but, even if the compilation is not finished, when I retried to compile iwl version 0.1.2, it works. Now for me is impossible to  understand, and I'm tring the way to make mac802 subsys work. Can anyone help me....
> 
> Another little question... exist a way for make work the wireless led that is always off, even if the wireless works.
> 
> Sorry for the request and for the the bad english... it's a lot of time that I don't wrote to a english mailing list (the last was alsa).
> 
> Tank you 
> Alex
> 
> ----------------------------------------------------------------------
> Get a free email account with anti spam protection.
> http://www.bluebottle.com/tag/2
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
John W. Linville
linville@tuxdriver.com
