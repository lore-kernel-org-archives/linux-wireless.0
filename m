Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35348 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761359Ab3DCMXh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 08:23:37 -0400
Message-ID: <1364991812.8351.25.camel@jlt4.sipsolutions.net> (sfid-20130403_142340_637329_F9F1F968)
Subject: Re: [RFC 0/3] mac80211: fixes for do_stop while suspended
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 03 Apr 2013 14:23:32 +0200
In-Reply-To: <20130329123321.GA22165@redhat.com>
References: <1364423602-18821-1-git-send-email-johannes@sipsolutions.net>
	 <20130329123321.GA22165@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-03-29 at 13:33 +0100, Stanislaw Gruszka wrote:

> Just tested (with 3/3 v2 patch) and it fixes the test case I have,
> that I used to create my patches. Test case is doing suspend with
> reverted commit 761ce8c41ed20ee3af77f2df527edc3f92e6f3bf. This make
> device is automatically removed/added during suspend, because lack 
> of .reset_resume callback.
> 
> Than I tested with physical remove device from USB slot while machine
> is suspend. This gives warnings in ieee80211_reconfig() and
> ieee80211_stop(). I'm not sure why, I'm going to look at that, but
> I think this patch set should be applied and some more fixes provided
> on top of it.

Sounds good. I'll send it as [PATCH] for the record.

johannes

