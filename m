Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55157 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab3AXPFS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 10:05:18 -0500
Message-ID: <1359039941.21908.4.camel@jlt4.sipsolutions.net> (sfid-20130124_160521_098887_3E7AF8D5)
Subject: Re: [PATCH] cfg80211: fix channel check in
 cfg80211_can_use_iftype_chan
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Thu, 24 Jan 2013 16:05:41 +0100
In-Reply-To: <1358950557-24405-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1358950557-24405-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-23 at 15:15 +0100, Simon Wunderlich wrote:
> In commit "cfg80211: check radar interface combinations" a regression
> was introduced which might lead to NULL dereference if the argument
> chan = NULL, which might happen in IBSS/wext case (and probably
> others).

Applied.

johannes

