Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45167 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbcF1Lmu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2016 07:42:50 -0400
Message-ID: <1467111044.2493.11.camel@sipsolutions.net> (sfid-20160628_134252_344028_B395A73D)
Subject: Re: [PATCH] mac80211: Use macro instead of number
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 28 Jun 2016 12:50:44 +0200
In-Reply-To: <1466594583-23663-1-git-send-email-masashi.honma@gmail.com> (sfid-20160622_132317_690872_6FC4A606)
References: <1466594583-23663-1-git-send-email-masashi.honma@gmail.com>
	 (sfid-20160622_132317_690872_6FC4A606)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-06-22 at 20:23 +0900, Masashi Honma wrote:
> Use IEEE80211_MIN_ACTION_SIZE macro for robust management frame
> check.
> 
Applied.

johannes
