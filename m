Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56454 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab1KUIB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 03:01:58 -0500
Received: by vcbfk1 with SMTP id fk1so5294161vcb.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2011 00:01:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFtRNNxH-7kU-Pq939aFupdOHW0ofeU7Ddqwg5pBoCu2JQp1wg@mail.gmail.com>
References: <CAFtRNNz6YEVp2efHqnh0aQ8DEdWm9-ztp8vRTmdorUjf8tJs5w@mail.gmail.com>
	<CAJ-Vmon3SsyQxOxpZxiCkbTJ60j-z7sXNgGUgiyAX9+-JzFMqQ@mail.gmail.com>
	<CAFtRNNxH-7kU-Pq939aFupdOHW0ofeU7Ddqwg5pBoCu2JQp1wg@mail.gmail.com>
Date: Mon, 21 Nov 2011 16:01:57 +0800
Message-ID: <CAJ-Vmo=o5=yqzp7+z2=aDe+4TqUAJ5yCCT_EP12o=CEJQqz-Vg@mail.gmail.com> (sfid-20111121_090206_938236_72F7B928)
Subject: Re: A weird hw crypto bug...
From: Adrian Chadd <adrian@freebsd.org>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Well, unless that vendor spun their own silicon, or there's something
funky on the board that'd change crypto behaviour, the only thing I
can really think of are EEPROM settings.
Or maybe the MAC revision is slightly different, I dunno.



Adrian
