Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:55580 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757118Ab1EMWVp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 18:21:45 -0400
Date: Sat, 14 May 2011 00:21:41 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: WPA in ad-hoc mode with carl9170
Message-ID: <20110513222141.GA11200@zenon.in.qult.net> (sfid-20110514_002148_826596_2DD4B60D)
References: <20110513160113.GA14293@zenon.in.qult.net>
 <BANLkTikiWNXnB6NcS48-1x9KYes_o=omjg@mail.gmail.com>
 <20110513174041.GA4690@zenon.in.qult.net>
 <201105132231.48232.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201105132231.48232.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 13, 2011 at 10:31:47PM +0200, thus spake Christian Lamparter:
> Note: there's a special bit [RX_MAC_CONTROL - bit 6] which instructs the key
> cache controller to do the "key security settings" lookup with addr2 for all
> bc/mc frames. If we enable this bit and modify carl9170_op_set_key to set the
> per station gtk correctly [i.e.: use sta->addr as MAC and put the keys into
> the per-sta space [0-63?]] we should be able to enable PER_STA_GTK...
> although the driver will be restricted to a single vif [I think].

If I understand correctly, by PER_STA_GTK you mean a different encryption key
for each one-hop neighbor.  It happens to be unnecessary in my case as one
"ad-hoc-global" encryption key would be enough.

> you should try your setup with mac80211_hwsim first [so we can rule out all
> driver bugs].

Good idea indeed.  I'll do that as soon as possible.

Thanks.

-- 
NO CARRIER
