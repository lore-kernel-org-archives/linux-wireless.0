Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:44293 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab0KKKqU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 05:46:20 -0500
Subject: Re: [PATCH v2 2/2] wl1271: add support for HW TX fragmentation
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Arik Nemtsov <arik@wizery.com>,
	John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1289209867-21422-3-git-send-email-arik@wizery.com>
References: <1289209867-21422-1-git-send-email-arik@wizery.com>
	 <1289209867-21422-3-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 12:45:42 +0200
Message-ID: <1289472342.1606.25.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-11-08 at 10:51 +0100, ext Arik Nemtsov wrote:
> Indicate to mac80211 we support HW fragmentation.
> Support updates of the fragmentation threshold via the
> set_frag_threshold callback.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Acked-by: Luciano Coelho <luciano.coelho@nokia.com>

John, can you apply this directly on your tree, due to the dependency on
mac80211? There will be a merge conflict with my next pull-request, due
to the driver renaming, but it should be very easily solvable.

The other option would be for me to wait until the mac80211 part is in
wireless-next and only then I apply it to wl12xx.

Which one would you prefer?

-- 
Cheers,
Luca.

