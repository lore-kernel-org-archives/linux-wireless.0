Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:57444 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758243AbYDBWvF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 18:51:05 -0400
From: Chr <chunkeey@web.de>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH] mac80211: add station aid into ieee80211_tx_control
Date: Thu, 3 Apr 2008 00:51:01 +0200
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John Linville" <linville@tuxdriver.com>
References: <200804012145.18294.chunkeey@web.de> <1207128858.10910.19.camel@johannes.berg> <1ba2fa240804021305o502d7e22o5ffebd0f466e4188@mail.gmail.com>
In-Reply-To: <1ba2fa240804021305o502d7e22o5ffebd0f466e4188@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804030051.02391.chunkeey@web.de> (sfid-20080402_235109_495512_FA341E9F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 02 April 2008 22:05:46 Tomas Winkler wrote:
> On Wed, Apr 2, 2008 at 12:34 PM, Johannes Berg
>
> <johannes@sipsolutions.net> wrote:
> >  On Tue, 2008-04-01 at 21:45 +0200, Chr wrote:
> >  > This patch is necessary for the upcoming Accesspoint patch for p54.
> >
> >  Hm. I don't like increasing the tx control structure size but I guess
> >  you really need that :)
> >
> >  > Signed-off-by: Christian Lamparter <chunkeey@web.de>
> >
> >  Acked-by: Johannes Berg <johannes@sipsolutions.net>
> >
> >  Please CC the appropriate maintainers (i.e. at least me for mac80211) on
> >  code changes.
>
> Not sure why this cannot be bookeeped in the driver.
> Upon association AID is delivered to driver, so every packet that will
> be sent to this AP has this AID?

hmm? where? sta_notify just gives us the mac-address and a command.
(maybe you have mixed it up with set_tim?!)

Or do I miss something obvious here?

Regards,
	Chr.




