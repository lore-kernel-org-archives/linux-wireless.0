Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:21820 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbYIQVq5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 17:46:57 -0400
Received: by rv-out-0506.google.com with SMTP id k40so3364456rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Sep 2008 14:46:56 -0700 (PDT)
Message-ID: <2da21fe50809171446y56cd5b2ctc864650be6030621@mail.gmail.com> (sfid-20080917_234703_985692_C15FAADA)
Date: Wed, 17 Sep 2008 23:46:56 +0200
From: "Davide Pesavento" <davidepesa@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iw packaging
Cc: "=?UTF-8?Q?Stefanik_G=C3=A1bor?=" <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1221683467.7412.6.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1221596962.9262.12.camel@johannes.berg>
	 <48D0DEF0.2060407@scram.de> <1221648205.9262.48.camel@johannes.berg>
	 <48D0E463.70008@le-vert.net> <1221649638.9262.50.camel@johannes.berg>
	 <48D0E5CE.8050401@le-vert.net>
	 <1221650286.9262.57.camel@johannes.berg>
	 <69e28c910809171319r30d763cse24744a198e41f92@mail.gmail.com>
	 <1221683467.7412.6.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

$ make
 GEN  version.h
 CC   iw.o
 CC   info.o
info.c: In function 'print_phy_handler':
info.c:108: error: 'NL80211_ATTR_SUPPORTED_IFTYPES' undeclared (first
use in this function)
info.c:108: error: (Each undeclared identifier is reported only once
info.c:108: error: for each function it appears in.)
make: *** [info.o] Error 1

I guess I have to build iw against >=2.6.27-rcX kernel headers, right?
