Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39037 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab1BXQLl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 11:11:41 -0500
Subject: Re: [PATCH] mac80211: make tx() operation return void
From: Johannes Berg <johannes@sipsolutions.net>
To: sedat.dilek@gmail.com
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTimaFrGObYC2x-XRo4waQKocLjZ34QYWDzLknAi7@mail.gmail.com>
References: <1298554926.4775.4.camel@jlt3.sipsolutions.net>
	 <AANLkTi=sRXPy8tmc4QYDQZfC-CqhGZpKpNeOR6b+OhhQ@mail.gmail.com>
	 <1298563114.4251.3.camel@jlt3.sipsolutions.net>
	 <AANLkTimaFrGObYC2x-XRo4waQKocLjZ34QYWDzLknAi7@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 17:11:37 +0100
Message-ID: <1298563897.4251.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-02-24 at 17:01 +0100, Sedat Dilek wrote:

> IIRC current linux-next and wireless-next don't differ, so it doesn't
> matter :-).

Ok :)

> I have removed only the drivers/staging/brcm80211/sys/wl_mac80211.c
> part as it does not exist in -next.

I see. I guess it'll have to get a different update then, but since it's
staging I'm not sure I can be bothered :-)

johannes

