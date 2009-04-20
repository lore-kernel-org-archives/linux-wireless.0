Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45093 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989AbZDTTpu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 15:45:50 -0400
Date: Mon, 20 Apr 2009 15:44:30 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/4] mac80211 powersave work
Message-ID: <20090420194430.GG3369@tuxdriver.com> (sfid-20090420_214554_212200_1F3E1944)
References: <20090416111723.904720021@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090416111723.904720021@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 16, 2009 at 01:17:23PM +0200, Johannes Berg wrote:
> This is pretty much unchanged from my previous v2 RFCs,
> except that I added a default of 500ms for the dynamic
> powersave timer.
> 
> The fourth patch is new, it adds beacon filtering to
> mac80211 -- for the reasons explained in that patch.
> 
> For 2.6.31, we should make MAC80211_DEFAULT_PS default
> off instead. John, how do you want to handle that?

I'm not sure I understand.  Your patch (which would go to 2.6.31)
has it turned-on by default.  Which way do you want it?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
