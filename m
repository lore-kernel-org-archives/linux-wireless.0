Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39169 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab3HWNoY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 09:44:24 -0400
Message-ID: <1377265461.14021.31.camel@jlt4.sipsolutions.net> (sfid-20130823_154427_944188_7DFC9B0C)
Subject: Re: [PATCH] mac80211: assign seqnums for group QoS frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Aug 2013 15:44:21 +0200
In-Reply-To: <1377264938-5333-1-git-send-email-me@bobcopeland.com> (sfid-20130823_153624_729867_B4CC1E3E)
References: <1377264938-5333-1-git-send-email-me@bobcopeland.com>
	 (sfid-20130823_153624_729867_B4CC1E3E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-08-23 at 09:35 -0400, Bob Copeland wrote:
> According to 802.11-2012 9.3.2.10, paragraph 4, QoS
> data frames with a group address in the Address 1 field
> have sequence numbers allocated from the same counter
> as non-QoS data and management frames.  Without this
> flag, some drivers may not assign sequence numbers, and
> in rare cases frames might get dropped.  Set the control
> flag accordingly.

Applied (to -next), thanks.

johannes

