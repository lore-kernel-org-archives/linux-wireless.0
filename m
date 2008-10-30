Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:8571 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbYJ3Fib (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 01:38:31 -0400
Received: by yx-out-2324.google.com with SMTP id 8so142808yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 22:38:30 -0700 (PDT)
Message-ID: <43e72e890810292238x36b37839x759c1691541534bf@mail.gmail.com> (sfid-20081030_063836_207134_14BE6F3C)
Date: Wed, 29 Oct 2008 22:38:30 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "jon doe" <mass.of.doughnuts@gmail.com>
Subject: Re: compile problems
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1225334965.25716.1.camel@indika.weed.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1225334965.25716.1.camel@indika.weed.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 29, 2008 at 7:49 PM, jon doe <mass.of.doughnuts@gmail.com> wrote:
> please help
>
> heres the error
>
> make -C /lib/modules/2.6.27.3-indika/build
> M=/home/jon/compat-wireless-2008-10-29 modules
> make[1]: Entering directory `/usr/src/linux-2.6.27.3'
>  CC      /home/jon/compat-wireless-2008-10-29/net/mac80211/main.o
> /home/jon/compat-wireless-2008-10-29/net/mac80211/main.c: In function
> 'ieee80211_handle_filtered_frame':
> /home/jon/compat-wireless-2008-10-29/net/mac80211/main.c:435: error:
> 'struct sk_buff' has no member named 'requeue'
> /home/jon/compat-wireless-2008-10-29/net/mac80211/main.c:437: error:
> 'struct sk_buff' has no member named 'requeue'
> make[3]: *** [/home/jon/compat-wireless-2008-10-29/net/mac80211/main.o]
> Error 1
> make[2]: *** [/home/jon/compat-wireless-2008-10-29/net/mac80211] Error 2
> make[1]: *** [_module_/home/jon/compat-wireless-2008-10-29] Error 2
> make[1]: Leaving directory `/usr/src/linux-2.6.27.3'
> make: *** [modules] Error 2

The compat code for aggregation wasn't added yet, but it should now be
there thanks to Tim. Please grab new tarball and try that.

git-describe says:
v2.6.28-rc2-4159-g6c11cd2
wireless-testing latest tag:
master-2008-10-29
This is compat-release:
v1.1-1-g1818f32


  Luis
