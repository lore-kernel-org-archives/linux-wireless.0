Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:54865 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbYKXHo0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 02:44:26 -0500
Received: by ey-out-2122.google.com with SMTP id 6so755732eyi.37
        for <linux-wireless@vger.kernel.org>; Sun, 23 Nov 2008 23:44:25 -0800 (PST)
Message-ID: <eb3ff54b0811232344v6e31413apd8756c127c4b1fbf@mail.gmail.com> (sfid-20081124_084439_186565_6C789AE2)
Date: Mon, 24 Nov 2008 09:44:25 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH 0/2] Enabling an AP that can't support fully PS clients (wireless-testing).
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net, j@w1.fi
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rThis patch set enables users who would prefer to have an AP
that can't support fully PS clients, rather than not having an AP at all.
The first patch adds this functionality in nl80211, and the second one
 adds this functionality in the zd1211rw driver.

 User space applications (like hostapd) will check the
NL80211_ATTR_WIPHY_AP_PS_CHALLENGED
attribute and display a proper message, if it is set,  to inform the
users that the AP does not support fully PS clients.

Regards,
Rami Rosen
