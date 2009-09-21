Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:58905 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbZIUGoh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2009 02:44:37 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] nl80211: introduce NL80211_ATTR_SCAN_EXPIRE
Date: Mon, 21 Sep 2009 08:42:59 +0200
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>
References: <200909181849.22302.hs4233@mail.mn-solutions.de> <1253293842.4787.1.camel@johannes.local>
In-Reply-To: <1253293842.4787.1.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200909210842.59852.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > It also allows to set an expiration for
> > NL80211_CMD_TRIGGER_SCAN. Setting the expiration to 0 will
> > clean the whole BSS list.
>
> tbh, I don't really understand the need for it. changing your
> AP settings doesn't seem like a use case anyone would really
> care about that much.

Turning of an AP is one way making the AP vanish.

Sitting into a fork-lift and driving throught a ware-house hall 
is another way to accomplish the same.

However, it's way easier for me to change the AP's setting than 
to actually leave me office :-)


/me wishes kernel developers would have more sense for real 
life :-)

-- 
http://www.holgerschurig.de
