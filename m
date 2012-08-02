Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47608 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab2HBNeI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 09:34:08 -0400
Message-ID: <1343914446.4471.1.camel@jlt3.sipsolutions.net> (sfid-20120802_153421_830595_8A94564C)
Subject: Re: [PATCH] cfg80211: Clear "beacon_found" on regulatory restore
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 02 Aug 2012 15:34:06 +0200
In-Reply-To: <20120802002723.7762E2056A@glenhelen.mtv.corp.google.com> (sfid-20120802_022727_815743_111F3AB3)
References: <20120802002723.7762E2056A@glenhelen.mtv.corp.google.com>
	 (sfid-20120802_022727_815743_111F3AB3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-08-01 at 16:54 -0700, Paul Stewart wrote:
> Restore the default state to the "beacon_found" flag when
> the channel flags are restored.  Otherwise, we can end up
> with a channel that we can no longer transmit on even when
> we can see beacons on that channel.

Makes sense, applied.

johannes

