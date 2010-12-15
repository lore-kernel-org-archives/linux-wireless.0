Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37640 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab0LOJ3R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 04:29:17 -0500
Subject: Re: [PATCH] mac80211: Add timeout to BA session start API
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <19720.35054.401355.825223@gargle.gargle.HOWL>
References: <19720.9510.589223.207856@gargle.gargle.HOWL>
	 <1292404347.3678.2.camel@jlt3.sipsolutions.net>
	 <19720.35054.401355.825223@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 10:29:14 +0100
Message-ID: <1292405354.3678.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-15 at 14:52 +0530, Sujith wrote:
> Johannes Berg wrote:
> > Maybe you need to make minstrel configurable here. Or maybe instead of
> > passing the value to the function directly, it should be a config option
> > in the hw struct? I'll let you sort that out with other people (Ivo?
> > Helmut? anyone else working on HT drivers?) -- I don't care since we
> > can't use minstrel for iwlwifi anyway.
> 
> Yep, I thought of making it a config option, but then it seemed cleaner to
> give the RC algorithm the freedom to decide dynamically the timeout value on a per-tid basis.
> (for ex. based on AP or managed mode, based on AC priority ..)

Indeed, that's another good point.

johannes

