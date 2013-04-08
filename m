Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53681 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab3DHShi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 14:37:38 -0400
Message-ID: <1365446248.25475.17.camel@jlt4.sipsolutions.net> (sfid-20130408_203747_889903_007ED716)
Subject: Re: [PATCH 3/6] mac80211: ieee80211_queue_stopped returns reasons
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Date: Mon, 08 Apr 2013 20:37:28 +0200
In-Reply-To: <1365444377-9959-3-git-send-email-thomas@cozybit.com> (sfid-20130408_200803_644541_3F7C6BDC)
References: <1365444377-9959-1-git-send-email-thomas@cozybit.com>
	 <1365444377-9959-3-git-send-email-thomas@cozybit.com>
	 (sfid-20130408_200803_644541_3F7C6BDC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-08 at 11:06 -0700, Thomas Pedersen wrote:
> Have ieee80211_queue_stopped() return a bitmap of enum
> queue_stop_reasons while checking queue status. This is
> handy when we care about the queue stop reason codes.

Nack. The driver must not care about the reasons, they're purely
internal to mac80211.

johannes

