Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56387 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbcCCPAq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 10:00:46 -0500
Message-ID: <1457017243.2044.15.camel@sipsolutions.net> (sfid-20160303_160049_355390_AFC00EC4)
Subject: Re: [PATCH 1/2] mac80211: document only injected *_RADIOTAP_* flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Sven Eckelmann <sven@narfation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Date: Thu, 03 Mar 2016 16:00:43 +0100
In-Reply-To: <1456327549-31765-1-git-send-email-sven@narfation.org>
References: <1456327549-31765-1-git-send-email-sven@narfation.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-02-24 at 16:25 +0100, Sven Eckelmann wrote:
> Not the internal flags but the radiotap flags are parsed when the
> monitor
> injected frames are prepared for transmission. Thus the documentation
> should only document these.
> 
Both applied.

johannes
