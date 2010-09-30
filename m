Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36839 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463Ab0I3VML (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 17:12:11 -0400
Message-Id: <20100930211013.472957770@sipsolutions.net>
Date: Thu, 30 Sep 2010 23:10:13 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: tgraf@suug.ch
Subject: [RFC 0/2] generic netlink doit generalisation
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

nl80211 does a lot of boilerplate work
for each generic netlink doit() operation,
this is an attempt to reduce it.

If you think this looks good, I'd like to
merge it through John's wireless tree.

johannes

