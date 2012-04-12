Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36621 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab2DLEFs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 00:05:48 -0400
Message-ID: <1334203508.3788.12.camel@jlt3.sipsolutions.net> (sfid-20120412_060551_041429_173B455D)
Subject: Re: [Greenmesh] [ath9k] mesh powersave hardware sleep + wakeup
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	javier@cozybit.com, linux-wireless@vger.kernel.org,
	henry@logout.com,
	"greenmesh@lists.osll.spb.ru" <greenmesh@lists.osll.spb.ru>
Date: Thu, 12 Apr 2012 06:05:08 +0200
In-Reply-To: <4F856449.3000804@etit.tu-chemnitz.de>
References: <4F630AEA.10703@etit.tu-chemnitz.de>
	 <20120316204547.GG18861@tux> <4F63BA31.1080608@etit.tu-chemnitz.de>
	 <4F856449.3000804@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-04-11 at 13:00 +0200, Marco Porsch wrote:

> Thus, I think we will need an additional/extended interface 
> mac80211<->driver here.
> 
> I see two possibilities:
> a) request the next wakeup time from mac80211 each time the hardware is 
> put to sleep (e.g. from ath9k_ps_restore).
> b) give a whole list of periodic wakeup events of all vif to the driver. 
> Then the driver is supposed to sort out the closest event.
> 
> What would be the better approach for such an interface? Or maybe a 
> completely different idea?

What time units would that be in, and how could you correlate them?

johannes

