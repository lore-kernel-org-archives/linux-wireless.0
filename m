Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60467 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2FIIk3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 04:40:29 -0400
Message-ID: <1339231227.4539.25.camel@jlt3.sipsolutions.net> (sfid-20120609_104035_448830_32C8ABA8)
Subject: Re: [PATCH v2 1/4] {nl,cfg,mac}80211: implement
 dot11MeshHWMProotInterval and dot11MeshHWMPactivePathToRootTimeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org
Date: Sat, 09 Jun 2012 10:40:27 +0200
In-Reply-To: <1339043963-2043-2-git-send-email-yeohchunyeow@gmail.com> (sfid-20120607_063949_035537_F6F9569E)
References: <1339043963-2043-1-git-send-email-yeohchunyeow@gmail.com>
	 <1339043963-2043-2-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20120607_063949_035537_F6F9569E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-07 at 12:39 +0800, Chun-Yeow Yeoh wrote:

> + * @NL80211_MESHCONF_HWMP_ACTIVE_PATH_TO_ROOT_TIMEOUT: The time (in TUs) for
> + * which mesh STAs receiving a proactive PREQ shall consider the forwarding
> + * information to the root mesh STA to be valid.

In a separate patch, somebody really needs to go in and make this match
the style used everywhere else in this file, that is a tab instead of a
space in the continuation lines:

 * @foo_member: bla bla bla ....
 *	bla bla bla

johannes

