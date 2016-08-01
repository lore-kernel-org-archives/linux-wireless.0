Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34150 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbcHAMUJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2016 08:20:09 -0400
Message-ID: <1470054005.17912.4.camel@sipsolutions.net> (sfid-20160801_142012_862648_08D10AB3)
Subject: Re: [PATCH 1/3 v6] mac80211: Refactor ieee80211_iface_work
From: Johannes Berg <johannes@sipsolutions.net>
To: Alex Briskin <br.shurik@gmail.com>, linux-wireless@vger.kernel.org
Date: Mon, 01 Aug 2016 14:20:05 +0200
In-Reply-To: <1468693140-19483-1-git-send-email-br.shurik@gmail.com> (sfid-20160716_201936_943619_6A75EF74)
References: <1468693140-19483-1-git-send-email-br.shurik@gmail.com>
	 (sfid-20160716_201936_943619_6A75EF74)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please don't submit three patches with identical subject.

> Added ieee80211_iface_work_handle_pkt_type function. Moved part of

Should also use present tense here - "Add ... function, move [...]".

This also applies to the other patches.

The if/else if/... -> switch change should also be part of this patch,
or separate, but not squashed together with a different unrelated
change. Might be worth moving "return 0" into each of the cases and
return an error in the fall-through, but it doesn't really matter.


johannes
