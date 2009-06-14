Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f207.google.com ([209.85.220.207]:57498 "EHLO
	mail-fx0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbZFNRuq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Jun 2009 13:50:46 -0400
Received: by fxm3 with SMTP id 3so174051fxm.37
        for <linux-wireless@vger.kernel.org>; Sun, 14 Jun 2009 10:50:47 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: add queue debugfs file
References: <1244993859.13033.22.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 14 Jun 2009 20:50:44 +0300
In-Reply-To: <1244993859.13033.22.camel@johannes.local> (Johannes Berg's message of "Sun\, 14 Jun 2009 17\:37\:39 +0200")
Message-ID: <87tz2in1qj.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> I suspect that some driver bugs can cause queues to be
> stopped while they shouldn't be, but it's hard to find
> out whether that is the case or not without having any
> visible information about the queues. This adds a file
> to debugfs that allows us to see the queues' statuses.

I have to admit that I have managed to do that sometimes with wl12xx, so
this is a welcomed debugging aid :)

-- 
Kalle Valo
