Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40110 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab2B2U1Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 15:27:24 -0500
Received: by bkcik5 with SMTP id ik5so2723490bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Feb 2012 12:27:23 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] carl9170: fix breakage from "mac80211: handle non-bufferable MMPDUs correctly"
Date: Wed, 29 Feb 2012 21:27:18 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <1330546305-26773-1-git-send-email-linville@tuxdriver.com> <1330546923.13717.9.camel@jlt3.sipsolutions.net>
In-Reply-To: <1330546923.13717.9.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201202292127.18915.chunkeey@googlemail.com> (sfid-20120229_212728_262583_942D5AFC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, February 29, 2012 09:22:03 PM Johannes Berg wrote:
> On Wed, 2012-02-29 at 15:11 -0500, John W. Linville wrote:
> > That commit intended for 3.4 renamed IEEE80211_TX_CTL_POLL_RESPONSE as
> > IEEE80211_TX_CTL_NO_PS_BUFFER.  Meanwhile, "carl9170: fix frame delivery
> > if sta is in powersave mode" added a reference to
> > IEEE80211_TX_CTL_POLL_RESPONSE in the fixes stream for 3.3.  This simple
> > patch fixes that merge boo-boo.
> 
> Thanks, sorry about the overlap.
Err?! I wrote and posted an updated patch on saturday.

[PATCH -wt] carl9170: fix frame delivery if sta is in powersave mode
http://www.spinics.net/lists/linux-wireless/msg85556.html

Regards,
	Chr
