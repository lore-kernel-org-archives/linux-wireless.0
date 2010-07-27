Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34361 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab0G0GhS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 02:37:18 -0400
Subject: Re: iwlwifi connection problems
From: Johannes Berg <johannes@sipsolutions.net>
To: Alex Romosan <romosan@sycorax.lbl.gov>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <87mxtd5xlq.fsf@sycorax.lbl.gov>
References: <87tynqvtu6.fsf@sycorax.lbl.gov>
	 <1279917523.10769.1.camel@wwguy-huron>
	 <1280135867.3693.5.camel@jlt3.sipsolutions.net>
	 <87mxtd5xlq.fsf@sycorax.lbl.gov>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 08:37:09 +0200
Message-ID: <1280212629.19098.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-07-26 at 21:59 -0700, Alex Romosan wrote:

> any ideas on how i can debug this? i tried to do a git-bisect but i
> didn't get anywhere. i have the driver compiled in the kernel if that
> makes any difference. as i played with the later kernels (after 2.6.34)
> i discovered that if kept bringing the interface down and then up again
> eventually i would get "cfg80211: Calling CRDA to update world
> regulatory domain" the antenna light on the laptop (i have a thinkpad
> t61) would go off and then at the next ifup the driver connected. looks
> like some kind of reset/initialization problem to me.

So is the issue maybe the channel the AP is no, not the fact that it's
hidden? or something like that?

johannes

