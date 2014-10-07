Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47741 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbaJGOJh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 10:09:37 -0400
Message-ID: <1412690969.1825.18.camel@jlt4.sipsolutions.net> (sfid-20141007_160941_044949_901381C7)
Subject: Re: [RFC] mac80211: enable DFS with channel contexts
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 07 Oct 2014 16:09:29 +0200
In-Reply-To: <CA+BoTQmrsA9Sk12ePaSaNqox2YOPjG0yqB2avRcB+a4qFgmz+w@mail.gmail.com> (sfid-20141007_154328_696584_5EA09D74)
References: <1412232304-7588-1-git-send-email-michal.kazior@tieto.com>
	 <1412671748.1825.4.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmrsA9Sk12ePaSaNqox2YOPjG0yqB2avRcB+a4qFgmz+w@mail.gmail.com>
	 (sfid-20141007_154328_696584_5EA09D74)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-10-07 at 15:43 +0200, Michal Kazior wrote:

> Correct. However ieee80211_radar_detected() takes only ieee80211_hw as
> an argument now. Skipping this check in mac80211 might bite later if
> someone extends cfg80211 later for multi-channel radar detection with
> non-mac80211 driver in mind and forgets about updating mac80211.

Yeah that's a good point.

> Or are you okay with relying on the cfg80211 check alone? If so I'll
> update the patch.

No, it's fine, just wanted to clarify.

johannes

