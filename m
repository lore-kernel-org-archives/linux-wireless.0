Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39452 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761620Ab3DDQFy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 12:05:54 -0400
Message-ID: <1365091547.8229.2.camel@jlt4.sipsolutions.net> (sfid-20130404_180619_434453_D34A1E28)
Subject: Re: [PATCH] lib80211: make lib80211 can be enabled independently
From: Johannes Berg <johannes@sipsolutions.net>
To: Wang YanQing <udknight@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Thu, 04 Apr 2013 18:05:47 +0200
In-Reply-To: <20130404160130.GA2577@udknight> (sfid-20130404_180146_336133_A89725C9)
References: <20130404160130.GA2577@udknight>
	 (sfid-20130404_180146_336133_A89725C9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-04-05 at 00:01 +0800, Wang YanQing wrote:
> Current we can only enable lib80211 by enable a driver
> in tree use it which will select it, but some out tree's
> drivers also use it, so I think it has sense to make lib80211
> can be enabled independently.
> 
> A example of the out tree's drivers use lib80211 is:
> hybird driver(wl) for Broadcom Corporation BCM43225 802.11b/g/n

Tough luck.

NACK.

johannes

