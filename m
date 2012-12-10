Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42240 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab2LJVvT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 16:51:19 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TiBFu-0002xF-FC
	for linux-wireless@vger.kernel.org; Mon, 10 Dec 2012 22:51:18 +0100
Message-ID: <1355176302.8083.18.camel@jlt4.sipsolutions.net> (sfid-20121210_225121_859622_79AA51D2)
Subject: Re: [PATCH] minstrel: update stats after processing status
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 10 Dec 2012 22:51:42 +0100
In-Reply-To: <1354539400-20470-1-git-send-email-johannes@sipsolutions.net> (sfid-20121203_135621_378787_B39B2CAA)
References: <1354539400-20470-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121203_135621_378787_B39B2CAA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-12-03 at 13:56 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Instead of updating stats before sending a packet,
> update them after processing the packet's status.
> This makes minstrel in line with minstrel_ht.

Applied.

johannes

