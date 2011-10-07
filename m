Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52860 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759997Ab1JGM5R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 08:57:17 -0400
Message-Id: <20111007125538.433891720@sipsolutions.net> (sfid-20111007_145720_868292_4FD18064)
Date: Fri, 07 Oct 2011 14:55:38 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] remove truesize workarounds
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The truesize mangling and orphaning of the skb
are workarounds for the old skb_truesize_check
that was really just checking the wrong thing;
davem removed that check a while ago.

johannes

