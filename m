Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48459
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081Ab0GMVgl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jul 2010 17:36:41 -0400
Date: Tue, 13 Jul 2010 14:36:55 -0700 (PDT)
Message-Id: <20100713.143655.226786247.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2010-07-13
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100713203639.GE3835@tuxdriver.com>
References: <20100713203639.GE3835@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 13 Jul 2010 16:36:40 -0400

> Here is the latest batch of wireless LAN goodies intended for 2.6.36.
> It is more-or-less the usual batch of driver updates, including ath9k,
> iwlwifi, rt2x00, and wl1271.  The usual flurry of mac80211 updates is
> missing, due mostly to Johannes attending to a personal obligation of a
> happy nature. :-)
> 
> Please let me know if there are problems!

Pulled, but please be on the lookout for things that add uses
of "attribute ((packed))" instead of "__packed".

Eric Dumazet converted all of drivers/net and I've been endlessly
seeing partial reverts and new additions of the explicit attribute in
wireless commits.

For example, see the things that got added to iwlwifi this time around.

Please fix them up, all of them, for the next pull request I see from
you.

Thanks!
