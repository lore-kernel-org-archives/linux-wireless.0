Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45148 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2IEOEA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 10:04:00 -0400
Message-ID: <1346853870.4364.20.camel@jlt4.sipsolutions.net> (sfid-20120905_160404_357525_0312A7C1)
Subject: Re: [PATCH] mac80211: Various small fixes for cfg.c:
 mpath_set_pinfo()
From: Johannes Berg <johannes@sipsolutions.net>
To: LEO Airwarosu Yoichi Shinoda <shinoda@jaist.ac.jp>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org
Date: Wed, 05 Sep 2012 16:04:30 +0200
In-Reply-To: <5811BCFB-A140-4A91-BF85-8074242B6000@jaist.ac.jp> (sfid-20120827_153807_127465_CC0D8428)
References: <5811BCFB-A140-4A91-BF85-8074242B6000@jaist.ac.jp>
	 (sfid-20120827_153807_127465_CC0D8428)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-08-27 at 22:28 +0900, LEO Airwarosu Yoichi Shinoda wrote:
> Various small fixes for net/mac80211/cfg.c:mpath_set_pinfo():
> Initialize *pinfo before filling members in, handle MESH_PATH_RESOLVED
> correctly, and remove bogus assignment; result in correct display
> of FLAGS values and meaningful EXPTIME for expired paths in iw utility.
> 
> Signed-off-by: Yoichi Shinoda <shinoda@jaist.ac.jp>

Applied, and I also prefer sizeof(*p)

johannes

