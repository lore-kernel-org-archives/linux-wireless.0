Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39863 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbYHYVfx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2008 17:35:53 -0400
Date: Mon, 25 Aug 2008 14:35:52 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Mateyko <mateyko5@o2.pl>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BUG?
Message-ID: <20080825213552.GK6007@tesla> (sfid-20080825_233556_891894_A13083D6)
References: <708b5462.3a2f801e.48b0382a.d8795@o2.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <708b5462.3a2f801e.48b0382a.d8795@o2.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 23, 2008 at 09:17:46AM -0700, Mateyko wrote:
> Here is output from console after typing "make"
> 
> 
> mateyko@********:~/Pulpit/compat-wireless-2008-08-06$ make
> /home/mateyko/Pulpit/compat-wireless-2008-08-06/config.mk:30: *** "ERROR: There is a bug with compat-wireless on 2.6.22. Remove me if you want to fix me". Stop.
> mateyko@********:~/Pulpit/compat-wireless-2008-08-06$ make install
> /home/mateyko/Pulpit/compat-wireless-2008-08-06/config.mk:30: *** "ERROR: There is a bug with compat-wireless on 2.6.22. Remove me if you want to fix me". Stop.
> mateyko@********:~/Pulpit/compat-wireless-2008-08-06$
> 
> 
> Btw i don't know how to use mailing list so any reply send to: mateyko5(at)o2.pl or mateyko(at)mateyko.net

The error indicates there is an oops (crash) you will get with
compat-wireless right now if you try to use it on 2.6.22. If someone
wants to fix it the bug then they can enable 2.6.22 support in
compat-wireless. I just haven't had time for this.

  Luis
