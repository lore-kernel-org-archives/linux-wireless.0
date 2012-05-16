Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50528 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758644Ab2EPRRt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 13:17:49 -0400
Date: Wed, 16 May 2012 13:07:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/3] AP mode channel setting simplification
Message-ID: <20120516170733.GE3508@tuxdriver.com> (sfid-20120516_191757_833409_BFE95636)
References: <20120511083413.778117363@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120511083413.778117363@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 11, 2012 at 10:34:13AM +0200, Johannes Berg wrote:
> Ath6kl stores the channel, while mac80211 tries to
> immediately apply it. The latter isn't great for
> multi-channel.
> 
> Change cfg80211 to store the channel, and give it
> to the driver (mac80211, ath6kl, etc.) only in the
> start_ap() function.
> 
> This simplifies ath6kl a lot, and while it doesn't
> make a difference to mac80211 today I think it'll
> make it simpler to implement multi-channel.
> 
> johannes

I had some trouble with applying at least 1/3, so I skipped this
batch as well.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
