Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45328 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab3KMStI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 13:49:08 -0500
Message-ID: <1384368545.14578.26.camel@jlt4.sipsolutions.net> (sfid-20131113_194912_120551_0A4E7882)
Subject: Re: [PATCH 5/5] cfg80211: add reg_get_dfs_region()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 13 Nov 2013 19:49:05 +0100
In-Reply-To: <1384365246-24768-6-git-send-email-mcgrof@do-not-panic.com> (sfid-20131113_185425_603869_CB0C329A)
References: <1384365246-24768-1-git-send-email-mcgrof@do-not-panic.com>
	 <1384365246-24768-6-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20131113_185425_603869_CB0C329A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-13 at 18:54 +0100, Luis R. Rodriguez wrote:
> This can be used outside of the regulatory context for any checks
> on the DFS region. The central cfg80211 dfs_region is always used
> and if it does not match with the wiphy a debug print is issued.

I'll leave this until we have a user.

johannes

