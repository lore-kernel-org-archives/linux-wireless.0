Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41430 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbYJ1UMK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 16:12:10 -0400
Date: Tue, 28 Oct 2008 21:13:42 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
	lcostantino@gmail.com, linux-wireless@vger.kernel.org,
	penberg@cs.helsinki.fi
Subject: w35und driver now in mainline/staging
Message-ID: <20081028201342.GA17362@elf.ucw.cz> (sfid-20081028_211215_915987_62742943)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

Just... the w35und driver is now in mainline, and works (well enough
to ssh over that; but I guess channel is hardcoded).

Big thanks go to Pekka J Enberg for great cleanups.

Testers are needed; its easy, just grab latest 2.6.28-rc2, enable
staging, enable w35und... and more testing would be helpful.

BTW does anyone know the  name of the chip used in w35und? Or the
names of the finished cards? Something should go to the Kconfig help...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
