Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:53924 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbYKGVMD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 16:12:03 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 07 Nov 2008 13:12:03 -0800
Date: Fri, 7 Nov 2008 13:12:00 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] cfg80211: mark regdomains with >
	NL80211_MAX_SUPP_REG_RULES invalid
Message-ID: <20081107211200.GB5912@tesla> (sfid-20081107_221208_253196_EF2631E6)
References: <1226004327-10290-1-git-send-email-lrodriguez@atheros.com> <1226004327-10290-2-git-send-email-lrodriguez@atheros.com> <1226004327-10290-3-git-send-email-lrodriguez@atheros.com> <1226091963.11203.12.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1226091963.11203.12.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 07, 2008 at 01:06:02PM -0800, Johannes Berg wrote:
> On Thu, 2008-11-06 at 12:45 -0800, Luis R. Rodriguez wrote:
> > Lets remain consistent and mark rds with > NL80211_MAX_SUPP_REG_RULES
> > number of reg rules as invalid in is_valid_rd().
> > 
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> 
> Seems fine, if that's not userspace triggerable, but it isn't, right?

Nope, nl80211 has a check of its own, hence the addition of the
WARN_ON().

> Acked-by: Johannes Berg <johannes@sipsolutions.net>

Thanks,

  Luis
