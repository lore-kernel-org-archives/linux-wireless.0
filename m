Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:58092 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921Ab1A0JwG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 04:52:06 -0500
Subject: Re: [PATCH 05/10] wl12xx: report invalid TX rate when returning
 non-TX-ed skbs
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1295156534-4178-6-git-send-email-arik@wizery.com>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
	 <1295156534-4178-6-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Jan 2011 11:51:41 +0200
Message-ID: <1296121901.5263.116.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-01-16 at 06:42 +0100, Arik Nemtsov wrote:
> Report a TX rate idx of -1 when returning untransmitted skbs to mac80211
> using ieee80211_tx_status(). Otherwise mac80211 tries to use the
> returned (essentially garbage) status.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Is this a documented way of doing it or it just happens to work?

-- 
Cheers,
Luca.

