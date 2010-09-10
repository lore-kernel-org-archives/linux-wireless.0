Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55951 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab0IJVMI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 17:12:08 -0400
To: Ben Greear <greearb@candelatech.com>
Subject: Re: RFC:  v3: Support multiple STA on same AP with ath9k
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date: Fri, 10 Sep 2010 23:12:04 +0200
From: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
In-Reply-To: <4C8A8FF8.4030900@candelatech.com>
References: <4C8A8FF8.4030900@candelatech.com>
Message-ID: <fc41890c0792e7440941448d5b8b9169@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 10 Sep 2010 13:07:20 -0700, Ben Greear <greearb@candelatech.com>
wrote:
> It also consolidates some of the util.c iterator logic in
> mac80211.

That really ought to be a different patch.

And I don't think I like the counting in mac80211 -- it's just overhead
(EXPORT_SYMBOL etc) and a very simple implementation in the driver itself.

johannes
