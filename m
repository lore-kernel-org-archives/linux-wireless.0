Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43440 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab0G1VEJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 17:04:09 -0400
Subject: Re: [ath5k-devel] [PATCH] ath5k: add led_disable module option
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <AANLkTim_Yr0Hx58GHYPfiPxRBWjspuFUd64epUHn_4La@mail.gmail.com>
References: <1280334711-6141-1-git-send-email-linville@tuxdriver.com>
	 <AANLkTim_Yr0Hx58GHYPfiPxRBWjspuFUd64epUHn_4La@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 23:04:04 +0200
Message-ID: <1280351044.3732.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-07-28 at 14:01 -0700, Luis R. Rodriguez wrote:
> On Wed, Jul 28, 2010 at 9:31 AM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > Not everyone agrees about LED behaviour...give them an escape hatch that
> > will at least stop the lights from annoying them.
> >
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> I wonder if we can just do this on cfg80211 through a debugfs knob,
> which would take care of all device drivers?

We have proper API for this in sysfs if anybody bothered to hook this up
through the LED class/trigger system

johannes

