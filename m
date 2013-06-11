Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38807 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab3FKTYf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 15:24:35 -0400
Message-ID: <1370978668.8356.67.camel@jlt4.sipsolutions.net> (sfid-20130611_212439_539392_32A4BA1D)
Subject: Re: [PATCH] carl9170: make use of the new rate control API
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas =?ISO-8859-1?Q?H=FChn?= <thomas@net.t-labs.tu-berlin.de>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@nbd.name
Date: Tue, 11 Jun 2013 21:24:28 +0200
In-Reply-To: <1E3747D2-BD9C-4136-B17F-9227E24136D5@net.t-labs.tu-berlin.de>
References: <1370966237-27716-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 <201306111946.22682.chunkeey@googlemail.com>
	 <1E3747D2-BD9C-4136-B17F-9227E24136D5@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-11 at 21:17 +0200, Thomas Hühn wrote:
> Hi Christian,
> 
> I have not seen that patch in wireless-next, that's why I overlooked it… sorry.
> 
> > 
> > ???
> > 
> > carl9170 already supports the new rate control API (Patch from 2013-04-23).
> > <http://permalink.gmane.org/gmane.linux.kernel.wireless.general/107657>
> > 
> > Can you please tell me what you think is missing?
> > 
> 
> You patch looks good to me.
> As I just saw an ath9k patch for rcu protection when ieee80211_get_tx_rates() is called.
> Should this be done in carl9170 as well ?

I think that patch is wrong actually, probably should just do the rcu
protection inside the function. However the patch is completely wrong
anyway (C isn't python) so ...

johannes

