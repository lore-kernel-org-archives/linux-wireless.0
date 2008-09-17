Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52332 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbYIQVw4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 17:52:56 -0400
Subject: Re: iw packaging
From: Johannes Berg <johannes@sipsolutions.net>
To: Davide Pesavento <davidepesa@gmail.com>
Cc: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <2da21fe50809171446y56cd5b2ctc864650be6030621@mail.gmail.com> (sfid-20080917_234700_559966_9B8DC833)
References: <1221596962.9262.12.camel@johannes.berg>
	 <48D0DEF0.2060407@scram.de> <1221648205.9262.48.camel@johannes.berg>
	 <48D0E463.70008@le-vert.net> <1221649638.9262.50.camel@johannes.berg>
	 <48D0E5CE.8050401@le-vert.net> <1221650286.9262.57.camel@johannes.berg>
	 <69e28c910809171319r30d763cse24744a198e41f92@mail.gmail.com>
	 <1221683467.7412.6.camel@localhost>
	 <2da21fe50809171446y56cd5b2ctc864650be6030621@mail.gmail.com>
	 (sfid-20080917_234700_559966_9B8DC833)
Content-Type: text/plain
Date: Wed, 17 Sep 2008 23:52:46 +0200
Message-Id: <1221688366.7412.13.camel@localhost> (sfid-20080917_235258_927075_57271CEB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-09-17 at 23:46 +0200, Davide Pesavento wrote:
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

Actually this one is new in wireless-testing, I have a branch you can
build against 2.6.27 but it's not very up-to-date.

Any ideas how to handle this are welcome. Should it just ship the header
file? I'd prefer not to, otoh doing it isn't really harmful because when
adding a new command clearly you need to edit iw sources.

johannes

