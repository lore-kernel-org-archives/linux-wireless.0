Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpout06-04.prod.mesa1.secureserver.net ([64.202.165.227]:38174
	"HELO smtpout06.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1751714AbXGXSgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2007 14:36:05 -0400
Message-ID: <46A64503.1080003@seclark.us>
Date: Tue, 24 Jul 2007 14:29:23 -0400
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Axj <axjslack@bluebottle.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] Request for help...
References: <1185289332.46a61474a444c@mail.bluebottle.com> <20070724161226.GA24344@tuxdriver.com>
In-Reply-To: <20070724161226.GA24344@tuxdriver.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Just being a user I am not sure what you mean by come back to working 
with community? None of
their stuff is hidden is it? Does "the community" make it so hard to get 
stuff included that it is
not worth the pain for Intel?

Just wondering.

Steve

John W. Linville wrote:

>Since Intel continues to develop their mac80211 fork
>on their own, you will have to seek support from them at
>ipw3945-devel@lists.sourceforge.net.
>
>I keep hearing that Intel intends to come back to working with the
>community on mac80211.  Alas, that has yet to happen.  I want to
>believe that it will soon...?
>
>John
>
>On Tue, Jul 24, 2007 at 08:02:12AM -0700, Axj wrote:
>  
>
>>Hi, I'm alex....
>>
>>I have a notebook Acer Aspire 5920G, with an intel 4965 wireless, system is a Slackware 12 and kernel is my personal recompiled version of 2.6.21.5. 
>>
>>Usually I use the drivers of the version 0.0.* with macsubsystem version 8.0.2, but I've tried to compile the version 0.1.2... a lot of compilation problem. So I think to use  mac9.0.2..... 
>>after the make modules of these it's arrived this message.... 
>>
>>
>>net/mac80211/wme.c: In function 'ieee80211_ht_agg_queue_add':
>>net/mac80211/wme.c:759: error: dereferencing pointer to incomplete type
>>net/mac80211/wme.c: In function 'ieee80211_ht_agg_queue_remove':
>>net/mac80211/wme.c:784: error: dereferencing pointer to incomplete type
>>make[2]: *** [net/mac80211/wme.o] Error 1
>>make[1]: *** [net/mac80211] Error 2
>>make: *** [net] Error 2
>>
>>
>>so I can't compile the new version, but, even if the compilation is not finished, when I retried to compile iwl version 0.1.2, it works. Now for me is impossible to  understand, and I'm tring the way to make mac802 subsys work. Can anyone help me....
>>
>>Another little question... exist a way for make work the wireless led that is always off, even if the wireless works.
>>
>>Sorry for the request and for the the bad english... it's a lot of time that I don't wrote to a english mailing list (the last was alsa).
>>
>>Tank you 
>>Alex
>>
>>----------------------------------------------------------------------
>>Get a free email account with anti spam protection.
>>http://www.bluebottle.com/tag/2
>>
>>-
>>To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>    
>>
>
>  
>


-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



