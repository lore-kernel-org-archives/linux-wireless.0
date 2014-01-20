Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59850 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaATKzk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 05:55:40 -0500
Message-ID: <1390215337.4335.11.camel@jlt4.sipsolutions.net> (sfid-20140120_115543_059607_B8BFA8F0)
Subject: Re: [PATCH 4/5] cfg80211: introduce strict bandwidth regulatory flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com
Date: Mon, 20 Jan 2014 11:55:37 +0100
In-Reply-To: <1389947524-6102-5-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140117_093219_715721_9B28F3F7)
References: <1389947524-6102-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1389947524-6102-5-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140117_093219_715721_9B28F3F7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-01-17 at 09:32 +0100, Janusz Dziedzic wrote:
> Introduce NL80211_RRF_STRICT_BW regulatory rule flag.
> This mean we will check only banwidth defined in
> regulatory database and not check contiguous rules.

If you meant for this to alleviate my concerns about crda/db.txt
compatibility, you didn't do it right. This has no value whatsoever
since it still breaks things.

johannes


