Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48097 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab0FGJFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 05:05:22 -0400
Subject: Re: [PATCH v3 1/3] cfg80211: Add nl80211 antenna configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100607065858.16060.38448.stgit@tt-desk>
References: <20100607065858.16060.38448.stgit@tt-desk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 11:05:14 +0200
Message-ID: <1275901514.3639.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-06-07 at 15:58 +0900, Bruno Randolf wrote:

> + * @NL80211_CMD_GET_ANTENNA: Get antenna configuration from driver.

Since we already have runtime configuration and capability information
as part of the wiphy information printout, remind me again what was
wrong with adding antenna information there as well rather than having a
separate command to retrieve it?

As far as differentiating that information is concerned, you can easily
implement an iw "get antenna" command by just partially printing the
wiphy information, for example, no?

johannes

