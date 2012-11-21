Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:54200
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083Ab2KUNrd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 08:47:33 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20652.56145.6291.392891@gargle.gargle.HOWL> (sfid-20121121_144736_326387_F0AB01D7)
Date: Wed, 21 Nov 2012 19:16:57 +0530
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Add debugfs callbacks for station addition/removal
In-Reply-To: <CANUX_P3e4ut9Jh25wXP7dOcvQh_YhuZ_LCkQV4QHpaNGrzbYuQ@mail.gmail.com>
References: <1353381362-437-1-git-send-email-sujith@msujith.org>
	<1353494712.10444.20.camel@jlt4.sipsolutions.net>
	<CANUX_P3e4ut9Jh25wXP7dOcvQh_YhuZ_LCkQV4QHpaNGrzbYuQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach wrote:
> Do you see value to add this for vif too?

Not sure, mac80211 currently doesn't have a per-VIF debugfs area.
Also, we have ieee80211_iterate_active_interfaces(), which could be used
by drivers.

Sujith
