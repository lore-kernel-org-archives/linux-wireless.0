Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34819 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab2FFIjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 04:39:51 -0400
Message-ID: <1338971990.4513.15.camel@jlt3.sipsolutions.net> (sfid-20120606_103955_269168_A87BC37E)
Subject: Re: [RFC 2/6] mac80211: introduce new ieee80211_ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 10:39:50 +0200
In-Reply-To: <1337342589-10617-3-git-send-email-michal.kazior@tieto.com>
References: <1337342589-10617-1-git-send-email-michal.kazior@tieto.com>
	 <1337342589-10617-3-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-05-18 at 14:03 +0200, Michal Kazior wrote:

> + * @change_channel_type: Notifies device driver about channel context
> + *	channel_type change which may happen when combining different vifs on
> + *	a same channel with different HTs.

Oh, so you did take this into account, but not in the first patch yet I
guess then.

These totally make sense to me. Not sure I see a need to split patch 2
and 3 though :-)

johannes

