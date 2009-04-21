Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38229 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbZDUNAw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 09:00:52 -0400
Date: Tue, 21 Apr 2009 08:58:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org
Subject: Re: p54: power save disable patch twice
Message-ID: <20090421125820.GE17805@tuxdriver.com> (sfid-20090421_150057_770394_5E47AA20)
References: <87hc0iftzh.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87hc0iftzh.fsf@litku.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 21, 2009 at 08:36:50AM +0300, Kalle Valo wrote:
> Hi John,
> 
> I noticed that latest wireless-testing had this patch twice:
> 
>     p54: deactivate broken powersave function
>     
>     This patch deactivates powersave in station mode.
>     
>     It does not work correctly yet, so the code does more harm than
>     good.
>     
>     Reported-by: Johannes Berg <johannes@sipsolutions.net>
>     Signed-off-by: Christian Lamparter <chunkeey@web.de>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> The first patch removes IEEE80211_HW_SUPPORTS_PS and
> IEEE80211_HW_PS_NULLFUNC_STACK, and the second patch removes only
> IEEE80211_HW_BEACON_FILTER. I assume that the idea was to remove
> everything in one go.

The original patch was against the master branch and did all of
them together.  But I sent it to 2.6.30, which didn't ahve the
beacon filter part.  So I applied it in two parts (more or less).
I probably should alter the commit message for the second part.

Thanks for the reminder!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
