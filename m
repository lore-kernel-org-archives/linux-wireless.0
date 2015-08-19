Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59012 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbbHSTxx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 15:53:53 -0400
Message-ID: <1440014031.2089.14.camel@sipsolutions.net> (sfid-20150819_215356_967396_780AE303)
Subject: Re: set channel from radiotap headers during injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Allan Matthew <allanm84@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Aug 2015 21:53:51 +0200
In-Reply-To: <CAEnVuW21Ocie0RUGv-UZU1U=n=mTinJ_nJa2uHQqVZz-11AbWA@mail.gmail.com> (sfid-20150819_215111_116864_8760F707)
References: <CAEnVuW0JnU5yuAYBWsRfOo_S=GUK5vZzr6XqnNHHOeufmT-uiQ@mail.gmail.com>
	 <CAEnVuW1FcyBj2+ti8U8KF+rM0xO_Q+rw6PxXqgWy8WO0vRX6yg@mail.gmail.com>
	 <1439983495.2089.7.camel@sipsolutions.net>
	 <CAEnVuW18e15hOjoMYRstjgu2cr5BFAtVHThAyZGqpMAdFUQrpQ@mail.gmail.com>
	 <1440007745.2089.11.camel@sipsolutions.net>
	 <CAEnVuW0m5jPMcQnC4inVF+8xubZbuyM-faP6Lebz26jvb4s-XA@mail.gmail.com>
	 <1440013262.2089.13.camel@sipsolutions.net>
	 <CAEnVuW21Ocie0RUGv-UZU1U=n=mTinJ_nJa2uHQqVZz-11AbWA@mail.gmail.com>
	 (sfid-20150819_215111_116864_8760F707)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-08-19 at 12:50 -0700, Allan Matthew wrote:
> Regarding the AP clients, could the AP send a power save or sleep
> notification telling clients its going away for awhile, then come 
> back after the specified time?
> 

No, the protocol has no such provision for the AP.

[also, please try to format your emails more readable, instead of just
tacking on something on the top]

johannes
