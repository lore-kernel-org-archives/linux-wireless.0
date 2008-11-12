Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35874
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751630AbYKLWjB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 17:39:01 -0500
Date: Wed, 12 Nov 2008 14:39:01 -0800 (PST)
Message-Id: <20081112.143901.224895622.davem@davemloft.net> (sfid-20081112_233907_226927_B7EB1C46)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-11-12
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081112222739.GK2411@tuxdriver.com>
References: <20081112222739.GK2411@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 12 Nov 2008 17:27:39 -0500

> A few fixes intended for 2.6.28.  Included are a couple of USB IDs, a
> mac80211 fix to avoid sleeping during RCU, and a nasty hack to hostap to
> make it's skb->cb trickery work again...
> 
> Please let me know if there are problems!

Pulled, thanks John.
