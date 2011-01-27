Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:60036 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529Ab1A0LmE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 06:42:04 -0500
Subject: Re: [PATCH 07/10] wl12xx: AP-mode - support HW based link PS
 monitoring
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1295156534-4178-8-git-send-email-arik@wizery.com>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
	 <1295156534-4178-8-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Jan 2011 13:41:57 +0200
Message-ID: <1296128517.5263.137.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-01-16 at 06:42 +0100, Arik Nemtsov wrote:
> When operating in AP mode the wl1271 hardware filters our null-data
> packets as well as management packets. This makes it impossible for
> mac80211 to monitor the PS mode by using the PM bit of incoming frames.

s/our/out/ here too.

-- 
Cheers,
Luca.

