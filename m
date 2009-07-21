Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:22519 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945AbZGUTgy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2009 15:36:54 -0400
Received: by fg-out-1718.google.com with SMTP id e12so777456fga.17
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2009 12:36:51 -0700 (PDT)
To: Joe Perches <joe@perches.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, luciano.coelho@nokia.com
Subject: Re: [PATCH 3/3] MAINTAINERS: add wl1251 wireless driver
References: <20090721191136.22374.69017.stgit@tikku>
	<20090721191154.22374.17349.stgit@tikku>
	<1248204540.31365.275.camel@Joe-Laptop.home>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 21 Jul 2009 22:36:44 +0300
In-Reply-To: <1248204540.31365.275.camel@Joe-Laptop.home> (Joe Perches's message of "Tue\, 21 Jul 2009 12\:29\:00 -0700")
Message-ID: <87ocrdsu9f.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

>> +F:	drivers/net/wireless/wl12xx/wl1251*
>
> Not that I'm asking you to maintain more than you want to,
> but why not:
>
> F:	drivers/net/wireless/wl12xx/

Just because Luciano will soon publish wl1271 driver (which will use
wl1271_ prefix) and he will be maintaining that part, no other reason.

But what should we do with the shared Makefile and Kconfig? Also in the
future we might share some of the code between 1251 and 1271. Any tips
for this?

-- 
Kalle Valo
