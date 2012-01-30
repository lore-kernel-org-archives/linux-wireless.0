Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58864 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab2A3BEN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jan 2012 20:04:13 -0500
Subject: Re: [PATCH] iw: add support for NL80211_CMD_SET_STATION event
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1327848635-28174-1-git-send-email-ordex@autistici.org>
References: <1327848635-28174-1-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 29 Jan 2012 17:04:02 -0800
Message-ID: <1327885442.4225.1.camel@jlt3.sipsolutions.net> (sfid-20120130_020416_681459_023CCFC4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-01-29 at 15:50 +0100, Antonio Quartulli wrote:
> This patch makes iw print an appropriate message in case of
> NL80211_CMD_SET_STATION event. Involved flag with their values are printed too.

How can you even generate this message?

johannes

