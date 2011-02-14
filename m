Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:60848 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753922Ab1BNM2Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 07:28:25 -0500
Date: Mon, 14 Feb 2011 14:28:18 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: reply to directed probes in IBSS
Message-ID: <20110214122818.GA6712@jm.kir.nu>
References: <1296564563.3989.0.camel@jlt3.sipsolutions.net>
 <AANLkTimEDvmp2RbLXdOf8vRrjzBKd+rLwqoreX+x3EdB@mail.gmail.com>
 <1297678357.3785.14.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297678357.3785.14.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 14, 2011 at 11:12:37AM +0100, Johannes Berg wrote:
> The real question though is -- do we want/need this? I can only find
> reference to this behaviour in the WMM spec.

Yes, we do want and need it. Peer capability discovery in RSN IBSS
depends on this (or a potentially long wait on receiving Beacon frame
from the specific STA). IEEE 802.11REVmb clarifies the rules for IBSS in
10.4.4.3.2 which has the following statement on this: "A STA in an IBSS
shall respond to Probe Request frames sent to the individual address of
the STA." after the sentence that limits responding to just the STA
that transmitted the last Beacon frame.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
