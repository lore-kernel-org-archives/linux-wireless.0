Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42553 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab3A1NrJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 08:47:09 -0500
Message-ID: <1359380852.8120.19.camel@jlt4.sipsolutions.net> (sfid-20130128_144713_214316_14110652)
Subject: Re: [PATCH] mac80211: remove IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 28 Jan 2013 14:47:32 +0100
In-Reply-To: <1359380550-7798-1-git-send-email-sgruszka@redhat.com>
References: <1359380550-7798-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-01-28 at 14:42 +0100, Stanislaw Gruszka wrote:
> This is basically a revert of:
> 
> commit 5b632fe85ec82e5c43740b52e74c66df50a37db3
> Author: Stanislaw Gruszka <sgruszka@redhat.com>
> Date:   Mon Dec 3 12:56:33 2012 +0100
> 
>     mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
> 
> We do not need this flag any longer, rt2x00 BAR/BA problem was fixed
> correctly by wireless-testing commit:
> 
> commit 84e9e8ebd369679a958200a8baca96aafb2393bb
> Author: Helmut Schaa <helmut.schaa@googlemail.com>
> Date:   Thu Jan 17 17:34:32 2013 +0100
> 
>     rt2x00: Improve TX status handling for BlockAckReq frames

Applied, thanks.

johannes

