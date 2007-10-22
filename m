Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hpsmtp-eml19.KPNXCHANGE.COM ([213.75.38.84]:25833 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755989AbXJVSh4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2007 14:37:56 -0400
From: Frans Pop <elendil@planet.nl>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [ath5k] Help needed for Trust Speedshare Turbo Pro (PCMCIA)
Date: Mon, 22 Oct 2007 20:37:53 +0200
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
References: <200710211316.06772.elendil@planet.nl> <200710221925.37758.elendil@planet.nl> <40f31dec0710221113h79301530pad834f1825989656@mail.gmail.com>
In-Reply-To: <40f31dec0710221113h79301530pad834f1825989656@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710222037.53760.elendil@planet.nl> (sfid-20071022_193851_335470_AD3CE710)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 22 October 2007, Nick Kossifidis wrote:
> 2007/10/22, Frans Pop <elendil@planet.nl>:
> > OK. Thanks for the info.
> > I'd gotten the impression that the driver was a bit further along. No
> > problem though. I'll just stay alert for announcements.
>
> Your card is a 5213 and doesn't have 5110 PHY (it's a bug in ath_info
> i'm working on it -it reports phy version id = 0 sometimes and that
> matches 5110's version id, ath5k doesn't hve that bug), problem is
> that it is a b/g only card and we didn't have such cards to test. I'll
> send some patches soon that might fix b/g only PHYs but i can't
> guarantee anything ;-(

That would be excellent.
I'll be happy to test any patches. I'm sure we'll get there in the end :-)
