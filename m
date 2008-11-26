Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:44269 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbYKZExi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 23:53:38 -0500
Received: by rv-out-0506.google.com with SMTP id k40so288684rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2008 20:53:37 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18732.54720.739365.435163@localhost.localdomain> (sfid-20081126_055342_327816_7B6916BC)
Date: Wed, 26 Nov 2008 10:21:12 +0530
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [RFC] nl80211: Add frequency configuration (including HT40)
In-Reply-To: <20081125190533.GA27879@jm.kir.nu>
References: <20081125190533.GA27879@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen wrote:
> + * @NL80211_ATTR_WIPHY_FREQ: frequency of the selected channel in MHz
> + * @NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET: included with NL80211_ATTR_WIPHY_FREQ
> + *	if HT40 (40 MHz channels) are allowed:
> + *	NL80211_SEC_CHAN_BELOW = secondary channel is below the primary channel
> + *	NL80211_SEC_CHAN_ABOVE = secondary channel is above the primary channel

The driver needs to know if the selected channel is HT or not.
It receives only HT20/HT40+/HT40- flags, but a HT/non-HT flag is required too.

Sujith
