Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42954 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750841AbcLEOCT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 09:02:19 -0500
Message-ID: <1480946529.31788.8.camel@sipsolutions.net> (sfid-20161205_150221_359966_DB36A478)
Subject: Re: [PATCH] mac80211: Suppress NEW_PEER_CANDIDATE event if no room
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org, me@bobcopeland.com
Date: Mon, 05 Dec 2016 15:02:09 +0100
In-Reply-To: <1480464364-5054-1-git-send-email-masashi.honma@gmail.com> (sfid-20161130_010619_619017_21132536)
References: <1480464364-5054-1-git-send-email-masashi.honma@gmail.com>
         (sfid-20161130_010619_619017_21132536)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-11-30 at 09:06 +0900, Masashi Honma wrote:
> Previously, kernel sends NEW_PEER_CANDIDATE event to user land even
> if the found peer does not have any room to accept other peer. This
> causes continuous connection trials.

Thanks, applied.

johannes
