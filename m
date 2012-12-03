Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39707 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab2LCKWD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 05:22:03 -0500
Message-ID: <1354530144.9717.0.camel@jlt4.sipsolutions.net> (sfid-20121203_112207_527506_072AA943)
Subject: Re: [PATCH 1/2] mac80211: return if CSA is not handle
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Mon, 03 Dec 2012 11:22:24 +0100
In-Reply-To: <1354299448-19928-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1354299448-19928-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-30 at 19:17 +0100, Simon Wunderlich wrote:
> If channel contexts are enabled, the CSA should not be processed
> further. A return is missing here.

Thanks, applied both.

johannes

