Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:46673
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992923AbXBQRbL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Feb 2007 12:31:11 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: More breakage in wireless-dev.git
Date: Sat, 17 Feb 2007 18:30:37 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <1171690868.31103.17.camel@dv> <20070217114436.jhcgs4soo4sgo8sk@webmail.spamcop.net> <200702171755.36291.mb@bu3sch.de>
In-Reply-To: <200702171755.36291.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702171830.38104.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 17 February 2007 17:55, Michael Buesch wrote:
> > wlan0: starting scan
> > bcm43xx_d80211: Reconfiguring PHYmode to A-PHY
> 
> Oh, heh. Well. Does your device have an A-PHY?
> If not, it's related to a bug I am fixing at the moment. ;)

Well, anyway, this should be fixed in my tree now by
ignoring A-PHYs, as we don't support them, yet.

The slab error on the end of your dmesg is interresting, though.

-- 
Greetings Michael.
