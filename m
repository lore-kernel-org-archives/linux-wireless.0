Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:48368 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752225Ab0L1JBO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 04:01:14 -0500
Date: Tue, 28 Dec 2010 11:01:02 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bruno Randolf <br1@einfach.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, mcgrof@gmail.com
Subject: Re: [PATCH RFC] mac80211: Extend channel to frequency mapping for
 802.11j
Message-ID: <20101228090102.GA22580@jm.kir.nu>
References: <20101224074410.16337.90008.stgit@localhost6.localdomain6>
 <1293447459.3544.1.camel@jlt3.sipsolutions.net>
 <201012281431.46536.br1@einfach.org>
 <1293525513.3526.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1293525513.3526.0.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 28, 2010 at 09:38:33AM +0100, Johannes Berg wrote:
> Not really. I guess it seems fine. Do you know if there are ever any
> starting values used other than 4900 and 5000?

Quite a few.. At least 4.85 GHz and 3.0 GHz for 20 MHz channels and more
for 5 and 10 MHz channels (4.9375 GHz, 4.89 GHz, 3.0025 GHz, 4.0025 GHz,
5.0025 GHz) in channels defined by IEEE 802.11.

-- 
Jouni Malinen                                            PGP id EFC895FA
