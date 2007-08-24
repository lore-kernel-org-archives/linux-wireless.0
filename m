Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:34759
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbXHXVSn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 17:18:43 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 06/15] mac80211: remove TKIP mixing for hw accel again
Date: Fri, 24 Aug 2007 23:17:10 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20070824122705.549190000@sipsolutions.net> <20070824122905.967634000@sipsolutions.net>
In-Reply-To: <20070824122905.967634000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708242317.10822.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 24 August 2007 14:27:11 Johannes Berg wrote:
> The TKIP mixing code was added for the benefit of Intel's ipw3945
> chipset but that code ended up not using it. We have previously
> identified many problems with this code and it crystallized that
> library functions for mixing are likely to handle this in much
> more generality and might allow b43 to take advantage of hardware
> acceleration for TKIP.
> 
> Due to these reasons, remove the TKIP mixing for hardware
> accelerated crypto operations.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Acked-by: Michael Buesch <mb@bu3sch.de>

-- 
Greetings Michael.
