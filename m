Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59079 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbbB0Muf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2015 07:50:35 -0500
Message-ID: <1425041427.1960.1.camel@sipsolutions.net> (sfid-20150227_135038_921784_14B098F4)
Subject: Re: [PATCH v2 3/4] mac80211: initialize rate control earlier for
 tdls station
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Puzyniak <marek.puzyniak@tieto.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Fri, 27 Feb 2015 13:50:27 +0100
In-Reply-To: <1424850911-21017-4-git-send-email-marek.puzyniak@tieto.com> (sfid-20150225_085335_433402_71CE8ACD)
References: <1424850911-21017-1-git-send-email-marek.puzyniak@tieto.com>
	 <1424850911-21017-4-git-send-email-marek.puzyniak@tieto.com>
	 (sfid-20150225_085335_433402_71CE8ACD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+Arik.

It'd be nice (for me anyway) if you didn't send this in a series of
other patches I don't care about - I only ever saw this due to
patchwork.

On Wed, 2015-02-25 at 08:55 +0100, Marek Puzyniak wrote:
> Currently when TDLS station in driver goes from assoc
> to authorized state it can not use rate control parameters
> because rate control is not initialized yet. Some drivers
> require parameters already initialized by rate control when
> entering authorized state. It can be done by initializing
> rate control after station transition to authorized state
> but before notifying driver about that.

Arik, you have a similar patch handling only NSS. Does this one look
fine to you, and would it solve the problem your other patch solved?

johannes

