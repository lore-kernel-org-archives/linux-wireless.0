Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:40898 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbZAGOvr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 09:51:47 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: validate SIOCSIWPOWER arguments better
References: <1231261955.3654.0.camel@johannes>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 07 Jan 2009 16:51:05 +0200
In-Reply-To: <1231261955.3654.0.camel@johannes> (ext Johannes Berg's message of "Tue\, 06 Jan 2009 18\:12\:35 +0100")
Message-ID: <87mye35fvq.fsf@nokia.com> (sfid-20090107_155152_633522_54045A9A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Don't accept any arguments we don't handle, 

Makes sense to me. wrq->disabled case is not checked because of the
ugly goto, but at least for me that looks ok.

> and return error codes instead of using an uninitialised stack
> value.

You refer to ps variable here, right? Yeah, I wrote that. Sorry.

> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Reviewed-by: Kalle Valo <kalle.valo@nokia.com>

-- 
Kalle Valo
