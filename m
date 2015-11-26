Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38351 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbbKZRsR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 12:48:17 -0500
Message-ID: <1448560094.2167.39.camel@sipsolutions.net> (sfid-20151126_184821_499298_9FB3FC6F)
Subject: Re: [PATCH v2 3/8] cfg80211: reg: Refactor calculation of bandwidth
 flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Sojka <sojkam1@fel.cvut.cz>, linux-wireless@vger.kernel.org
Cc: bernd.lehmann@volkswagen.de, s.sander@nordsys.de,
	wireless-regdb@lists.infradead.org, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com,
	Jan =?ISO-8859-1?Q?Kaisrl=EDk?= <kaisrja1@fel.cvut.cz>
Date: Thu, 26 Nov 2015 18:48:14 +0100
In-Reply-To: <1448303241-27747-4-git-send-email-sojkam1@fel.cvut.cz> (sfid-20151123_192815_578111_C2D7CE4F)
References: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz>
	 <1448303241-27747-4-git-send-email-sojkam1@fel.cvut.cz>
	 (sfid-20151123_192815_578111_C2D7CE4F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-11-23 at 19:27 +0100, Michal Sojka wrote:
> The same piece of code appears at two places. Make a function from
> it.
> 
Also applied.

johannes
