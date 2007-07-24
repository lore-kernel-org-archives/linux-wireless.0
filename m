Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mi0.bluebottle.com ([206.188.25.15]:41588 "EHLO
	mi0.bluebottle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbXGXPMR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2007 11:12:17 -0400
Received: from fe1.bluebottle.com (internal.bluebottle.com [206.188.24.43])
	by mi0.bluebottle.com (8.13.1/8.13.1) with ESMTP id l6OF2F1Q031925
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2007 08:02:16 -0700
Received: from localhost (internal.bluebottle.com [206.188.24.43])
	(authenticated bits=0)
	by fe1.bluebottle.com (8.13.1/8.13.1) with ESMTP id l6OF2CZ8006370
	for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2007 08:02:15 -0700
To: linux-wireless@vger.kernel.org
Message-ID: <1185289332.46a61474a444c@mail.bluebottle.com>
Date: Tue, 24 Jul 2007 08:02:12 -0700
From: Axj <axjslack@bluebottle.com>
Subject: Request for help...
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, I'm alex....

I have a notebook Acer Aspire 5920G, with an intel 4965 wireless, system is a Slackware 12 and kernel is my personal recompiled version of 2.6.21.5. 

Usually I use the drivers of the version 0.0.* with macsubsystem version 8.0.2, but I've tried to compile the version 0.1.2... a lot of compilation problem. So I think to use  mac9.0.2..... 
after the make modules of these it's arrived this message.... 


net/mac80211/wme.c: In function 'ieee80211_ht_agg_queue_add':
net/mac80211/wme.c:759: error: dereferencing pointer to incomplete type
net/mac80211/wme.c: In function 'ieee80211_ht_agg_queue_remove':
net/mac80211/wme.c:784: error: dereferencing pointer to incomplete type
make[2]: *** [net/mac80211/wme.o] Error 1
make[1]: *** [net/mac80211] Error 2
make: *** [net] Error 2


so I can't compile the new version, but, even if the compilation is not finished, when I retried to compile iwl version 0.1.2, it works. Now for me is impossible to  understand, and I'm tring the way to make mac802 subsys work. Can anyone help me....

Another little question... exist a way for make work the wireless led that is always off, even if the wireless works.

Sorry for the request and for the the bad english... it's a lot of time that I don't wrote to a english mailing list (the last was alsa).

Tank you 
Alex

----------------------------------------------------------------------
Get a free email account with anti spam protection.
http://www.bluebottle.com/tag/2

