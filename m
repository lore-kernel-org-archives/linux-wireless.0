Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48652 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab2K2RoY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 12:44:24 -0500
Message-ID: <1354211077.879.3.camel@jlt4.sipsolutions.net> (sfid-20121129_184430_164164_20505747)
Subject: Re: [PATCH] nl80211: Fix HT_IBSS feature check in ibss_join
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Thu, 29 Nov 2012 18:44:37 +0100
In-Reply-To: <1354210642-13355-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1354210642-13355-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-29 at 18:37 +0100, Simon Wunderlich wrote:
> There is a standalone if, seems to be a regression of commit
> "nl80211/cfg80211: add VHT MCS support".

Oops, thanks. Applied.

johannes

