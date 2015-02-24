Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41105 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbbBXUEO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 15:04:14 -0500
Message-ID: <1424808245.2192.37.camel@sipsolutions.net> (sfid-20150224_210418_091632_AA375506)
Subject: Re: [PATCH v2] mac80211_hwsim: support any address in userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 24 Feb 2015 21:04:05 +0100
In-Reply-To: <1424785184-4427-1-git-send-email-me@bobcopeland.com> (sfid-20150224_144032_308851_A22E6BFC)
References: <1424785184-4427-1-git-send-email-me@bobcopeland.com>
	 (sfid-20150224_144032_308851_A22E6BFC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-02-24 at 08:39 -0500, Bob Copeland wrote:
> Due to the checks in get_hwsim_data_ref_from_addr, wmediumd
> was only able to use the second mac address (those starting with
> 0x42).  This is confusing and needlessly limiting, so allow any
> configured address.

Applied.

johannes

