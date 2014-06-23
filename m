Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45799 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbaFWMaI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 08:30:08 -0400
Message-ID: <1403526593.4418.22.camel@jlt4.sipsolutions.net> (sfid-20140623_143013_482815_1B3F45C5)
Subject: Re: [PATCH 01/10] mac80211: clarify TDLS Tx handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 23 Jun 2014 14:29:53 +0200
In-Reply-To: <1402496307-32522-1-git-send-email-arik@wizery.com> (sfid-20140611_161835_922389_96680E72)
References: <1402496307-32522-1-git-send-email-arik@wizery.com>
	 (sfid-20140611_161835_922389_96680E72)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Applied all - had to make some adjustments in patch 7 and while at it
made it use the per-vif functionality Luca added.

johannes

