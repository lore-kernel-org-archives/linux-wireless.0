Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34011 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbbIGKhM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 06:37:12 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Maxime Bizon <mbizon@freebox.fr>
Cc: Chor Teck Law <ctlaw@marvell.com>, David Lin <dlin@marvell.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pete Hsieh <peteh@marvell.com>
Subject: Re: [PATCH v5] Add new mac80211 driver mwlwifi.
References: <92d77d0990b94d23ae66fb69fb55a6fb@SC-EXCH02.marvell.com>
	<1436455659.36587.131.camel@sakura.staff.proxad.net>
	<87vbcvyokg.fsf@kamboji.qca.qualcomm.com>
	<db9a0d4afa9b435d8efa380715955bee@SC-EXCH03.marvell.com>
	<20150804224951.GA31383@sakura.staff.proxad.net>
Date: Mon, 07 Sep 2015 13:37:04 +0300
In-Reply-To: <20150804224951.GA31383@sakura.staff.proxad.net> (Maxime Bizon's
	message of "Wed, 5 Aug 2015 00:49:51 +0200")
Message-ID: <874mj6frcf.fsf@kamboji.qca.qualcomm.com> (sfid-20150907_123715_475649_3AADF6C6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maxime Bizon <mbizon@freebox.fr> writes:

> but from my POV, your pattern is: build new chipset, obsolete previous
> chipset, fork current firmware, make uncompatible changes to both
> firmware & host driver to accomodate new chipset peculiarities.
>
> and eventually, if a customer requests a mainline linux driver, then
> write one... this is what I'd call "dumping"

BTW, this is exactly what I meant with "dumping" as well. Having
multiple drivers with similar functionality is difficult for everyone.
Creating a new driver with new bugs is much worse than making smaller,
incremental changes to the existing driver. And of course code sharing
is always preferred, but not a hard requirement for drivers.

-- 
Kalle Valo
