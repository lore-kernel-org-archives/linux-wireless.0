Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37889 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932879Ab0JFSzF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 14:55:05 -0400
Subject: Re: [PATCH] mac80211: Deny new BA agreements from being started
 during offchannel operation
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	srinivasa.duvvuri@atheros.com, matt.smith@atheros.com,
	bennyam.malavazi@atheros.com, linux-wireless@vger.kernel.org
In-Reply-To: <20101006185000.GJ7070@tux>
References: <20101006185000.GJ7070@tux>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 20:55:01 +0200
Message-ID: <1286391301.3655.403.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-06 at 11:50 -0700, Luis R. Rodriguez wrote:
> It only makes sense to allow BA agreements when we are going to
> spend some time on the operating channel. This blocks all new
> incoming ADDBA requests while we go offchannel, but keeps
> existing BA agreements alive.

I just hope the different uses of this bit won't ever collide ... can we
suspend while being offchannel? ;-)

johannes

