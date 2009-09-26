Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2742 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbZIZMrW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2009 08:47:22 -0400
Date: Sat, 26 Sep 2009 08:46:20 -0400
From: Bob Copeland <me@bobcopeland.com>
To: hans.ullrich@loop.de
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: Fw: Cannot register at bugzilla (bugreport added) [ ath5k
	bugreport ]
Message-ID: <20090926124620.GA5188@hash.localnet>
References: <20090925191524.7b2b228c@schatten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090925191524.7b2b228c@schatten>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 25, 2009 at 07:15:24PM +0200, Florian Mickler wrote:
> cc's added
> 
> could you also:
>  - tell the version of the broken kernel, 
>  - the last working kernel version, 
>  - test if it works with current kernel-snapshot from
>    http://www.kernel.org/ 

Yes, please.

> kernel-module "ath5k" gets no IP when using dhcp
> 
> Description: It is not possible, to get an IP-address by using dhcp
> with the kernel-module ath5k. It is possible, to give a fixed IP to
> that module.

It works here - I would guess the packets are getting dropped.
Do you have anything in 'dmesg' while trying to associate?

> There are already other reports of this problem in discussion forums.
> It seems, the old madwifi-driver works better with dhcp - so people say.

Can you point to such a discussion?  It's best to discuss on ath5k-devel
or linux-wireless ML so we will know about it.

-- 
Bob Copeland %% www.bobcopeland.com

