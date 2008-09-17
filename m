Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:21320 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYIQVvz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 17:51:55 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3212205wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 17 Sep 2008 14:51:54 -0700 (PDT)
Message-ID: <69e28c910809171451p7f996175nd63bb3208b638ff2@mail.gmail.com> (sfid-20080917_235159_312185_FE2384BB)
Date: Wed, 17 Sep 2008 23:51:54 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Davide Pesavento" <davidepesa@gmail.com>
Subject: Re: iw packaging
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <2da21fe50809171446y56cd5b2ctc864650be6030621@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1221596962.9262.12.camel@johannes.berg>
	 <48D0DEF0.2060407@scram.de> <1221648205.9262.48.camel@johannes.berg>
	 <48D0E463.70008@le-vert.net> <1221649638.9262.50.camel@johannes.berg>
	 <48D0E5CE.8050401@le-vert.net>
	 <1221650286.9262.57.camel@johannes.berg>
	 <69e28c910809171319r30d763cse24744a198e41f92@mail.gmail.com>
	 <1221683467.7412.6.camel@localhost>
	 <2da21fe50809171446y56cd5b2ctc864650be6030621@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 17, 2008 at 11:46 PM, Davide Pesavento <davidepesa@gmail.com> wrote:
> $ make
>  GEN  version.h
>  CC   iw.o
>  CC   info.o
> info.c: In function 'print_phy_handler':
> info.c:108: error: 'NL80211_ATTR_SUPPORTED_IFTYPES' undeclared (first
> use in this function)
> info.c:108: error: (Each undeclared identifier is reported only once
> info.c:108: error: for each function it appears in.)
> make: *** [info.o] Error 1
>
> I guess I have to build iw against >=2.6.27-rcX kernel headers, right?
>

That's exactly why I branched for aircrack-ng. Maybe we should use our
own copy of nl80211.h, as shipping with headers that are different
from/incompatible with the sources is not something that most distros
will do.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
