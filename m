Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40470 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbbHYRsk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2015 13:48:40 -0400
Message-ID: <1440524917.2192.52.camel@sipsolutions.net> (sfid-20150825_194843_395201_2067C07C)
Subject: Re: set channel from radiotap headers during injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Allan Matthew <allanm84@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 25 Aug 2015 19:48:37 +0200
In-Reply-To: <CAEnVuW1FiS+DX-TUC4iQkutgE1U3k9Os-xqGgBAOBxich0xbtg@mail.gmail.com> (sfid-20150825_194729_793844_CA1E9183)
References: <CAEnVuW0JnU5yuAYBWsRfOo_S=GUK5vZzr6XqnNHHOeufmT-uiQ@mail.gmail.com>
	 <CAEnVuW1FcyBj2+ti8U8KF+rM0xO_Q+rw6PxXqgWy8WO0vRX6yg@mail.gmail.com>
	 <1439983495.2089.7.camel@sipsolutions.net>
	 <CAEnVuW18e15hOjoMYRstjgu2cr5BFAtVHThAyZGqpMAdFUQrpQ@mail.gmail.com>
	 <1440007745.2089.11.camel@sipsolutions.net>
	 <CAEnVuW0m5jPMcQnC4inVF+8xubZbuyM-faP6Lebz26jvb4s-XA@mail.gmail.com>
	 <1440013262.2089.13.camel@sipsolutions.net>
	 <CAEnVuW21Ocie0RUGv-UZU1U=n=mTinJ_nJa2uHQqVZz-11AbWA@mail.gmail.com>
	 <1440014031.2089.14.camel@sipsolutions.net>
	 <CAEnVuW3LHHDUpJzaKoDAcYkBoT8B5ddQM2Va33xtxA-ORgLH3w@mail.gmail.com>
	 <CAEnVuW28F2g_x65UzvH-RGpLON+YR2KoJ7dM=3j7gP11VJ8WEg@mail.gmail.com>
	 <1440495409.2192.16.camel@sipsolutions.net>
	 <CAEnVuW1FiS+DX-TUC4iQkutgE1U3k9Os-xqGgBAOBxich0xbtg@mail.gmail.com>
	 (sfid-20150825_194729_793844_CA1E9183)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-08-25 at 10:47 -0700, Allan Matthew wrote:
> 
> Where would I stick the transmit power control?  In the
> ieee80211_tx_info->control somewhere, or maybe in the
> ieee80211_tx_info->rate_driver_data?

It's got to be in control, but not sure where - perhaps look at
minstrel blues stuff?

johannes
