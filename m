Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:42343 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068Ab3AGGKi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 01:10:38 -0500
Message-ID: <1357538977.22318.22.camel@cumari.coelho.fi> (sfid-20130107_071046_969379_C32A369C)
Subject: Re: [patch net-next] net: use ETHTOOL_FWVERS_LEN instead of
 ETHTOOL_BUSINFO_LEN for fw_ver strings
From: Luciano Coelho <coelho@ti.com>
To: David Miller <davem@davemloft.net>
CC: <jiri@resnulli.us>, <netdev@vger.kernel.org>,
	<linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Date: Mon, 7 Jan 2013 08:09:37 +0200
In-Reply-To: <20130106.220523.1783238632929635985.davem@davemloft.net>
References: <1357474371-30887-1-git-send-email-jiri@resnulli.us>
	 <1357538335.22318.19.camel@cumari.coelho.fi>
	 <20130106.220523.1783238632929635985.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-01-06 at 22:05 -0800, David Miller wrote:
> From: Luciano Coelho <coelho@ti.com>
> Date: Mon, 7 Jan 2013 07:58:55 +0200
> 
> > Hi Jiri,
> > 
> > On Sun, 2013-01-06 at 13:12 +0100, Jiri Pirko wrote:
> >> Signed-off-by: Jiri Pirko <jiri@resnulli.us>
> >> ---
> > 
> > Please add a commit message explaining why this change is needed.
> 
> It's obvious, not such commit message is necessary.

Hmmm, okay.  I just always prefer to see a commit message.  If not for
more clarity, at least so that the commit looks more "balanced" in the
log.

Anyway, for the wlcore part:

Acked-by: Luciano Coelho <coelho@ti.com>

