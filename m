Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 84-16-245-18.internetserviceteam.com ([84.16.245.18]:47291 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757895AbXFJRhX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jun 2007 13:37:23 -0400
Message-ID: <466C2F94.8050501@hauke-m.de>
Date: Sun, 10 Jun 2007 19:06:28 +0200
From: linux-wireless@hauke-m.de
MIME-Version: 1.0
To: David Planella <david.planella@googlemail.com>
Cc: acx100-devel@lists.sourceforge.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: The future of the TI ACX wireless driver
References: <1d9d9b240706100735k374b5800ie64370e1e9bff1ef@mail.gmail.com>
In-Reply-To: <1d9d9b240706100735k374b5800ie64370e1e9bff1ef@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi

Nice work David.

I have extracted the acxsm driver out of the wireless-2.6 git tree and
made it compile on at least kernel 2.6.20 and 2.6.22-rc4
It can be found here:
http://www.hauke-m.de/fileadmin/acx/tiacx-20070522.tar.bz2

I also chanced some lines in the normal acx driver so it compiles with
kenrel 2.6.22 and later
http://www.hauke-m.de/fileadmin/acx/acx-20070610.tar.bz2

Bouth are loading on my system, but I can't test them because I haven't
got any acx100 chip based card any more, it would be nice to get
positive feedback, when it's working.

I will write some pages into the Wiki for these versions, so everyone
can test them.

I am not a big kernel hacker but I want to learn it too.

Hauke Mehrtens
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGbC+UrcX0gpXFjnsRAiZvAJ9HqeLhYD71ziIY8nn1/s165IgW9wCeOkta
jcvdcupbincXF0WpXVQse5s=
=1Dty
-----END PGP SIGNATURE-----
