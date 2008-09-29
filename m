Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:40781 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbYI2I6t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 04:58:49 -0400
Message-ID: <1504.194.45.26.221.1222678723.squirrel@webmail.madwifi.org> (sfid-20080929_105852_636702_81450B72)
In-Reply-To: <200809282216.46416.pete@petezilla.co.uk>
References: <200809281734.01027.pete@petezilla.co.uk>
    <40f31dec0809281018l6a2fdacwf03ddf0f2876c1a2@mail.gmail.com>
    <200809282216.46416.pete@petezilla.co.uk>
Date: Mon, 29 Sep 2008 10:58:43 +0200 (CEST)
Subject: Re: SMC wireless card, unknown Atheros/Accton chipset?
From: "Michael Renzmann" <mrenzmann@madwifi.org>
To: "Peter Chant" <pete@petezilla.co.uk>
Cc: "Nick Kossifidis" <mickflemm@gmail.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

Peter Chant wrote:
> I'm a bit of a wireless newbie.  Do you mind me asking whether it is
> likely to support being an access point?  I noticed that in general
> cards don't work as access points, is it a chipset limitation or is
> it just a whole load of work for something that is not much in demand?

It's currently a limitation of mac80211. Changing that is work in progress
for mac80211, and there is an experimental patch available for ath5k that
enable the driver part of AP support. The patch was posted here just a few
days ago [1].

Bye, Mike

[1] http://thread.gmane.org/gmane.linux.drivers.ath5k.devel/1240

