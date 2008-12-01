Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:21128 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbYLAP4R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 10:56:17 -0500
To: "Vivek Natarajan" <vivek.natraj@gmail.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Vivek Natarajan" <vnatarajan@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: Enhancements to dynamic power save.
References: <20081202011754.GA9382@myhost.users.atheros.com>
	<1228132431.3478.21.camel@johannes.berg>
	<8e92b4100812010708r78aab0fdt9cb101df97fcc29@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 01 Dec 2008 17:55:38 +0200
In-Reply-To: <8e92b4100812010708r78aab0fdt9cb101df97fcc29@mail.gmail.com> (ext Vivek Natarajan's message of "Mon\, 1 Dec 2008 20\:38\:33 +0530")
Message-ID: <87oczv6gat.fsf@nokia.com> (sfid-20081201_165620_718570_E296D57D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <vivek.natraj@gmail.com> writes:

>> One thing I forgot, do we need a special iwlwifi flag to turn this off?

Or a flag to turn it on? Either of them are fine, I guess.

> Kalle added a flag 'IEEE80211_HW_NO_DYNAMIC_PS' in v3 RFC.
> May be, it can be used for iwlwifi to use its own power save and
> null frames as it does now instead of using from mac80211.
> We can check this flag and then change CONF_PS wherever it is used.

I think we should have a separate hw flag for null frames.

-- 
Kalle Valo
