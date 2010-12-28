Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55839 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab0L1JIG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 04:08:06 -0500
Subject: Re: [PATCH RFC] mac80211: Extend channel to frequency mapping for
 802.11j
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Bruno Randolf <br1@einfach.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, mcgrof@gmail.com
In-Reply-To: <20101228090102.GA22580@jm.kir.nu>
References: <20101224074410.16337.90008.stgit@localhost6.localdomain6>
	 <1293447459.3544.1.camel@jlt3.sipsolutions.net>
	 <201012281431.46536.br1@einfach.org>
	 <1293525513.3526.0.camel@jlt3.sipsolutions.net>
	 <20101228090102.GA22580@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Dec 2010 10:08:02 +0100
Message-ID: <1293527282.3526.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-28 at 11:01 +0200, Jouni Malinen wrote:
> On Tue, Dec 28, 2010 at 09:38:33AM +0100, Johannes Berg wrote:
> > Not really. I guess it seems fine. Do you know if there are ever any
> > starting values used other than 4900 and 5000?
> 
> Quite a few.. At least 4.85 GHz and 3.0 GHz for 20 MHz channels and more
> for 5 and 10 MHz channels (4.9375 GHz, 4.89 GHz, 3.0025 GHz, 4.0025 GHz,
> 5.0025 GHz) in channels defined by IEEE 802.11.

That's what I kinda thought ... doesn't that mean this patch is
insufficient?

johannes

