Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41585 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709AbbIXOKI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 10:10:08 -0400
Message-ID: <1443103799.1869.6.camel@sipsolutions.net> (sfid-20150924_161037_733791_BC7A189C)
Subject: Re: [PATCH 18/19] mac80211: make ieee80211_new_mesh_header return
 unsigned
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrzej Hajda <a.hajda@samsung.com>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Thu, 24 Sep 2015 16:09:59 +0200
In-Reply-To: <1443103227-25612-19-git-send-email-a.hajda@samsung.com>
References: <1443103227-25612-1-git-send-email-a.hajda@samsung.com>
	 <1443103227-25612-19-git-send-email-a.hajda@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-09-24 at 16:00 +0200, Andrzej Hajda wrote:
> The function returns always non-negative values.
> 
> The problem has been detected using proposed semantic patch
> scripts/coccinelle/tests/assign_signed_to_unsigned.cocci [1].
> 
You should at least compile your patches.

johannes
