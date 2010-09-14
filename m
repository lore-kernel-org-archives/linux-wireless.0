Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44401 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab0INO3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 10:29:40 -0400
Subject: Re: [PATCH 07/10] mac80211: disable beacon monitor while going
 offchannel
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org, Paul Stewart <pstew@google.com>,
	Amod Bodas <amod.bodas@atheros.com>
In-Reply-To: <1284474028-3337-1-git-send-email-lrodriguez@atheros.com>
References: <1284474028-3337-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 16:29:37 +0200
Message-ID: <1284474577.3704.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-14 at 10:20 -0400, Luis R. Rodriguez wrote:

> +	del_timer_sync(&ifmgd->bcn_mon_timer);
>  	del_timer_sync(&sdata->u.mgd.conn_mon_timer);

This is kinda inconsistent now ... and you added both these lines in
your patch set :-)

johannes

