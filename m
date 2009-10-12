Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37937 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbZJLNbr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 09:31:47 -0400
Date: Mon, 12 Oct 2009 09:17:29 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: tomasw@gmail.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	yi.zhu@intel.com, inaky.perez-gonzalez@intel.com,
	cindy.h.kao@intel.com, guy.cohen@intel.com,
	ron.rindjunsky@intel.com
Subject: Re: [PATCH 1/3] iwmc3200top: Add Intel Wireless MultiCom 3200 top
	driver.
Message-ID: <20091012131729.GA27575@tuxdriver.com>
References: <1ba2fa240910100238s709c31d3s6cb612f502b1086f@mail.gmail.com> <20091010.185852.133969433.davem@davemloft.net> <1ba2fa240910110105x33fb251ar3437dd5fee552735@mail.gmail.com> <20091011.033647.66923614.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091011.033647.66923614.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 11, 2009 at 03:36:47AM -0700, David Miller wrote:
> From: Tomas Winkler <tomasw@gmail.com>
> Date: Sun, 11 Oct 2009 10:05:20 +0200
> 
> > Just close my eyes and there is new game to play. :)
> > It's not in the patchwork, so is there any reason you are not planning
> > to add it.   The patch intention was for net-next, it looks like
> > I didn't mark it as such, my fault.
> 
> Because there still seems to be some confusion between which of these
> bits go through John Linville as a wireless driver and which bits
> go directly through me.
> 
> By default I assume John picks up "wireless" drivers and send them
> to me in his wireless merges to me.
> 
> If that's not the case, explicitly do a fresh submission of this patch
> and explicitly ask me to merge it.

I was afraid this might get lost in the confusion.  I had other things
to worry about and since it crossed so many lines and was sent to
netdev, I figured I'd worry about it later if it got lost... :-(

FWIW, I think the wimax/bluetooth/wifi connection makes net-next-2.6
the right tree for this.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
