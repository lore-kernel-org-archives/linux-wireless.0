Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53147 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab2FRL62 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 07:58:28 -0400
Message-ID: <1340020705.4615.6.camel@jlt3.sipsolutions.net> (sfid-20120618_135832_175232_AADCB263)
Subject: Re: [PATCH] mac80211: fix and improve mesh RANN processing
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org
Date: Mon, 18 Jun 2012 13:58:25 +0200
In-Reply-To: <1339726802-14441-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120615_042127_079590_BFAD68AA)
References: <1339726802-14441-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20120615_042127_079590_BFAD68AA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-15 at 10:20 +0800, Chun-Yeow Yeoh wrote:
> This patch fixes the problem of dropping RANN element if the TTL
> is 1. If the received RANN element TTL is 1 or greater than 1, the
> RANN is processed. However, forwarding of received RANN element
> with TTL 1 or less is prohibited according to the standard. This
> is previously reported by Monthadar Al Jaberi.
> 
> Besides, this patch also avoid the processing of unicast PREQ
> generation if the RANN element does not meet the acceptance
> criteria mentioned in Sec. 13.10.12.4.2 of IEEE Std. 802.11-2012.
> 
> Reported-by: Monthadar Al Jaberi <monthadar@gmail.com>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>

Applied.

johannes

