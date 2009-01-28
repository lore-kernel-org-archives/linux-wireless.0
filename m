Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:30666 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZA1RAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 12:00:13 -0500
Received: by fg-out-1718.google.com with SMTP id 13so623936fge.17
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 09:00:11 -0800 (PST)
To: "Alina Friedrichsen" <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Subject: Re: [PATCH v2] mac80211: Creating new IBSS with fixed BSSID
References: <20090128153012.138700@gmx.net>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 28 Jan 2009 19:00:07 +0200
In-Reply-To: <20090128153012.138700@gmx.net> (Alina Friedrichsen's message of "Wed\, 28 Jan 2009 16\:30\:12 +0100")
Message-ID: <87k58f74dk.fsf@litku.valot.fi> (sfid-20090128_180018_416967_219D9346)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Alina Friedrichsen" <x-alina@gmx.net> writes:

> This fixes a bug when creating a new IBSS network with a fixed BSSID. The fixed BSSID situation is now with one of my last patches handled in ieee80211_sta_find_ibss() function.
>
> It's more robust to test against (ifsta->flags & IEEE80211_STA_PREV_BSSID_SET), because ifsta->state is not seted right in every situation and so the creating of the new IBSS network sometimes hangs after the first try to scan for a network to merge.

Please line wrap your commit logs. Now you had very long lines.

-- 
Kalle Valo
