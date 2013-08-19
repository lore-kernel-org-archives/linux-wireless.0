Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f172.google.com ([209.85.128.172]:65177 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3HSPph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Aug 2013 11:45:37 -0400
Received: by mail-ve0-f172.google.com with SMTP id oz10so3208455veb.31
        for <linux-wireless@vger.kernel.org>; Mon, 19 Aug 2013 08:45:36 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 19 Aug 2013 08:45:36 -0700
Message-ID: <CA+55aFwSF9e5hHMQgmbmoyPm0Z-YJK43ycgnB8ZkXtsL6xSaTA@mail.gmail.com> (sfid-20130819_174540_576480_952E41DA)
Subject: Wireless disassociations..
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>,
	John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes.berg@intel.com>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is anybody following this bugzilla?

   https://bugzilla.kernel.org/show_bug.cgi?id=60690

it has a bisection in it, and a patch?

The patch is a bit odd, but quite frankly, the current values for
IEEE80211_HT_PARAM_CHA_SEC_xxx are (a) odd and (b) used very oddly
too. Is it possible that that 0x03 really should be 0x02?

                Linus
