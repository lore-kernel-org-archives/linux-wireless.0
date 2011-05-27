Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33925 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab1E0TZW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2011 15:25:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
Reply-To: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: skip disabled channels on channel survey
References: <1306506242-7552-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1306506242-7552-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 27 May 2011 15:28:53 -0400
Message-Id: <1306524533.11997.2.camel@Nokia-N900-51-1> (sfid-20110527_212525_552341_9828F387)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> The channel survey information will be empy for
> disabled channels so simply discard those entries.

What if the channel was recently disabled?

Johannes
