Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:49981
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763501AbXEZUSN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2007 16:18:13 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx-mac80211: Fix for tx_bias equal to 0xFF
Date: Sat, 26 May 2007 22:18:08 +0200
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <465869ce.8wcEX9q9ZmHxX2m3%Larry.Finger@lwfinger.net> <200705261919.39143.mb@bu3sch.de> <46587492.6070106@lwfinger.net>
In-Reply-To: <46587492.6070106@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200705262218.08413.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 26 May 2007 19:55:30 Larry Finger wrote:
> With it, my 4311 connects with bcm43xx-mac80211. Without it, no connection.

Ok, it seems to fix the itssi thing, but that re-enables
txpower adjustment, which reveals the whole bunch of bugs in there. :)
So before I can merge this, I have to fix these bugs there.

-- 
Greetings Michael.
