Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37269 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab2J2JNF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 05:13:05 -0400
Message-ID: <1351502016.10925.9.camel@jlt4.sipsolutions.net> (sfid-20121029_101309_144140_CE022336)
Subject: Re: [PATCHv3 1/2] nl/cfg80211: add the NL80211_CMD_SET_MCAST_RATE
 command
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 29 Oct 2012 10:13:36 +0100
In-Reply-To: <1351267055-21927-1-git-send-email-ordex@autistici.org>
References: <1351267055-21927-1-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-10-26 at 17:57 +0200, Antonio Quartulli wrote:

> + * @NL80211_CMD_SET_MCAST_RATE: Change the rate used to send multicast frames
> + *	for IBSS or MESH vif.

You should probably advertise the new command, see nl80211_send_wiphy()

johannes

