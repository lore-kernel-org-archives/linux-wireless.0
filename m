Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38996 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab3H3KDW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Aug 2013 06:03:22 -0400
Message-ID: <1377856999.16256.1.camel@jlt4.sipsolutions.net> (sfid-20130830_120325_915258_82B42CD2)
Subject: Re: [PATCH] cfg80211: use the correct macro to check for active
 monitor support
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 30 Aug 2013 12:03:19 +0200
In-Reply-To: <1377772017-24764-1-git-send-email-luciano.coelho@intel.com>
References: <1377772017-24764-1-git-send-email-luciano.coelho@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-08-29 at 13:26 +0300, Luciano Coelho wrote:
> Use MONITOR_FLAG_ACTIVE, which is a flag mask, instead of
> NL80211_MNTR_FLAG_ACTIVE, which is a flag index, when checking if the
> hardware supports active monitoring.

Applied, thanks.

johannes

