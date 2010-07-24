Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47227 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab0GXHfj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jul 2010 03:35:39 -0400
Subject: Re: [PATCH] mac80211: Don't set per-BSS QoS for monitor interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Sujith <Sujith.Manoharan@atheros.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTim0Zv8E6Kc60W9m6krL-FOzXiJpeHTGgoR2DH9i@mail.gmail.com>
References: <19529.9687.183293.284789@gargle.gargle.HOWL>
	 <1279864868.3745.0.camel@jlt3.sipsolutions.net>
	 <AANLkTim0Zv8E6Kc60W9m6krL-FOzXiJpeHTGgoR2DH9i@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 24 Jul 2010 09:35:33 +0200
Message-ID: <1279956933.7737.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-07-23 at 10:29 -0700, Luis R. Rodriguez wrote:
> On Thu, Jul 22, 2010 at 11:01 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Fri, 2010-07-23 at 10:47 +0530, Sujith wrote:
> >> In AP mode, there is no need to notify the driver about QoS
> >> changes for the monitor interface that is created. The warning
> >> in ieee80211_bss_info_change_notify() would be hit otherwise.
> >
> > Makes sense.
> >
> > Acked-by: Johannes Berg <johannes@sipsolutions.net>
> >> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> 
> Stable?

Err, no, the change that does this isn't going in until .36 I think.

johannes

