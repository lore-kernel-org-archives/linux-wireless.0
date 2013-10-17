Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44022 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444Ab3JQOeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 10:34:37 -0400
Message-ID: <1382020473.14410.10.camel@jlt4.sipsolutions.net> (sfid-20131017_163440_618745_6B7C2D30)
Subject: Re: [PATCH 1/6] cfg80211: export reg_initiator_name()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Thu, 17 Oct 2013 16:34:33 +0200
In-Reply-To: <1381797731-2454-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20131015_024223_309972_DA356EC7)
References: <1381797731-2454-1-git-send-email-mcgrof@do-not-panic.com>
	 <1381797731-2454-2-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20131015_024223_309972_DA356EC7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-10-14 at 17:42 -0700, Luis R. Rodriguez wrote:
> Drivers can now use this to parse the regulatory request and
> be more verbose when needed.

Applied.

johannes

