Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:52498 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbYLEFw0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 00:52:26 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH v4 5/5] mac80211: track master queue status
References: <20081202200219.5507.83250.stgit@tikku>
	<20081202200426.5507.44042.stgit@tikku>
	<1228412076.5692.25.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Fri, 05 Dec 2008 07:51:56 +0200
In-Reply-To: <1228412076.5692.25.camel@johannes.berg> (ext Johannes Berg's message of "Thu\, 04 Dec 2008 18\:34\:35 +0100")
Message-ID: <87r64ni2yr.fsf@nokia.com> (sfid-20081205_065229_578895_076E21BE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> I wonder if we should optimise the spinlock here?

That would be nice, but how to do that?

> Also, I'd prefer to first add this with just a single DRIVER reason
> first, and then add the PS patches that add and use the second reason.

Yes, that's clean way to do it. I'll change it.

> Other than that, it looks good to me, thanks!

Thank you for all the help with this, much appreciated.

I'll send v5 of my patches later this week.

-- 
Kalle Valo
