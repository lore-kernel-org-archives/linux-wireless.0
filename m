Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43142 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab2HALJ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 07:09:59 -0400
Message-ID: <1343819395.4638.4.camel@jlt3.sipsolutions.net> (sfid-20120801_131002_820645_B45276F4)
Subject: Re: [PATCH] cfg80211: use correct (original) max power
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Hong Wu <Hong.Wu@dspg.com>, "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 01 Aug 2012 13:09:55 +0200
In-Reply-To: <1343812040.4638.3.camel@jlt3.sipsolutions.net> (sfid-20120801_110727_142881_01F13F13)
References: <1343811819-15582-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120801_110350_289489_AA41BA81) <1343812040.4638.3.camel@jlt3.sipsolutions.net>
	 (sfid-20120801_110727_142881_01F13F13)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-08-01 at 11:07 +0200, Johannes Berg wrote:
> On Wed, 2012-08-01 at 11:03 +0200, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > When calculating the maximum TX power for a channel,
> > the original maximum power should be restricted to
> > the current regulatory TX power. Restricting the
> > current maximum TX power has the effect that it'll
> > never be possible to increase the power again when
> > the regulatory requirement changes.
> 
> 
> No ... this isn't right either. Hong Wu, can you please fix this mess?

Never mind. Stanislaw already did fix this, I just forgot about it
because I was checking mac80211-next.git and had (of course) applied his
fix to mac80211.git. Sorry!

johannes

