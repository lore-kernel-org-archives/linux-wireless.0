Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:58202 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031AbXGIF3l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2007 01:29:41 -0400
Message-ID: <4691C7C0.1090101@warmcat.com>
Date: Mon, 09 Jul 2007 06:29:36 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Ulrich Kunitz <kune@deine-taler.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Jon Smirl <jonsmirl@gmail.com>, Daniel Drake <dsd@gentoo.org>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: Arrested Development
References: <468E5C33.2000102@warmcat.com> <20070708140054.GA28113@deine-taler.de> <46910F3F.8010201@warmcat.com> <9e4733910707081142t43a85fb1y383ee8e1835c2842@mail.gmail.com> <469130E8.1010608@warmcat.com> <9e4733910707081204l490e99fcm6b8780f36ef8b9a8@mail.gmail.com> <46913846.9000007@warmcat.com> <20070708203717.GA15957@deine-taler.de> <1183929814.3771.5.camel@johannes.berg> <46915B3C.6030609@warmcat.com> <20070708223829.GA18217@deine-taler.de>
In-Reply-To: <20070708223829.GA18217@deine-taler.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ulrich Kunitz wrote:

> I forgot to mention that the monitor support doesn't work with
> additonal interfaces right now. Additional interfaces are broken
> currently for zd1211rw. I cannot fix all the problems with
> mac80211 interface of the driver at the same time.

Understood, I appreciate the work you and Daniel are putting in.  Over
the past few months the zd1211rw-mac80211 has been pretty much my
reference platform since it was more stable than the other devices I
have during that time.

> Try
> 
> iwconfig wlan0 mode monitor
> ifconfig wlan0 up
> iwconfig wlan0 channel 6
> 
> for now.
> 
> The problem with the STA + MNTR interface is, that mac80211 must
> do the FCS checking for the STA interface or the driver has to
> filter them before forwarding them to the upper layer.

Yep that works now thanks, I see encrypted data and ACKs spamming and
the occasional bogon.  BTW I quite like having the bogons too... in
Monitor mode anyway.

-Andy


