Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:28129 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960Ab1CIOyB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 09:54:01 -0500
Date: Wed, 9 Mar 2011 09:53:57 -0500
From: Jason <linuxdriverproject@lakedaemon.net>
To: George Nychis <gnychis@gmail.com>
Cc: linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	hharte2@gmail.com, devel@linuxdriverproject.org
Subject: Re: looking for more details on BCM4329, access to 802.11 header
Message-ID: <20110309145357.GD10509@titan.lakedaemon.net>
References: <AANLkTikwBUjSXJf+EUeM+kPhMg3PG0Y22S4BYKVVm8S2@mail.gmail.com> <20110307140140.GC10509@titan.lakedaemon.net> <AANLkTi=TaeNnJ3u+HXojkbHvjsH+Z7C_=3Tg98NMNg1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTi=TaeNnJ3u+HXojkbHvjsH+Z7C_=3Tg98NMNg1A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 09, 2011 at 12:59:33AM -0500, George Nychis wrote:
> This was a *huge* help to get this response from you, thanks a bunch for that.
> 

No problem, I wish this particular idea could be higher on my project
list. ;-)

> I'd love to poke GregKG's staging tree and the mac80211 driver for the

s/GregKG/GregKH/

> bcm4329.  I did some searching for the staging tree, and the only
> address I could find was:
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> 

In my tree I did the following:
$ git remote add staging-2.6 \
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6.git

$ git remote update staging-2.6
...successful output...

So, it looks like you're using the old url, try this:

$ git clone \
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6.git

Then, you'll want the staging-next branch.

hth,

Jason.
