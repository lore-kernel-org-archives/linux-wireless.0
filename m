Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44217 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaAMNfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 08:35:47 -0500
Message-ID: <1389620141.5008.8.camel@jlt4.sipsolutions.net> (sfid-20140113_143551_377500_9246D545)
Subject: Re: [PATCH v5] wl12xx: fix tx power setting
From: Johannes Berg <johannes@sipsolutions.net>
To: Alex Gal <a.gal@motsai.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Mon, 13 Jan 2014 14:35:41 +0100
In-Reply-To: <1389385273-1322-1-git-send-email-a.gal@motsai.com> (sfid-20140110_212129_433831_3BAD5CCF)
References: <1389385273-1322-1-git-send-email-a.gal@motsai.com>
	 (sfid-20140110_212129_433831_3BAD5CCF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-01-10 at 15:21 -0500, Alex Gal wrote:
> The driver ignores BSS_CHANGED_TXPOWER changes.
> Fix this by calling ACX_TX_POWER when appropriate.

This doesn't really make sense since the driver handles
IEEE80211_CONF_CHANGE_POWER. If there's something wrong with that, maybe
that should be fixed?

You should be able to see this with the debugging stuff.

johannes

