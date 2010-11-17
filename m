Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:47151 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758876Ab0KQIda (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 03:33:30 -0500
Subject: Re: [PATCH v2 2/2] wl1271: add support for HW TX fragmentation
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Arik Nemtsov <arik@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1289209867-21422-3-git-send-email-arik@wizery.com>
References: <1289209867-21422-1-git-send-email-arik@wizery.com>
	 <1289209867-21422-3-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 10:33:03 +0200
Message-ID: <1289982783.12140.0.camel@chilepepper>
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

Applied to the wl12xx tree.  Thanks!


-- 
Cheers,
Luca.

