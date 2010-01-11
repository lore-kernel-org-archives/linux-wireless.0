Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:37110 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab0AKWYC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2010 17:24:02 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 3/6] b43: N-PHY: add RSSI calculation for PHY rev < 3
Date: Mon, 11 Jan 2010 23:23:58 +0100
Cc: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	bcm43xx-dev@lists.berlios.de,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
References: <op.u6b70wtk9lhzdc@linux-g0th.site> <201001112313.26197.mb@bu3sch.de> <1263248392.29743.13.camel@johannes.local>
In-Reply-To: <1263248392.29743.13.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001112323.58399.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 11 January 2010 23:19:52 Johannes Berg wrote:
> On Mon, 2010-01-11 at 23:13 +0100, Michael Buesch wrote:
> 
> > No I don't think so.
> > It's C standard that uninitialized elements on automatic variables are
> > initialized
> > to zero, _if_ at least one element is initialized to something.
> > So if you init one element to 0, all others will be 0, too.
> 
> AFAIK, you don't even have to init anything, since otherwise not
> mentioned fields will be set to 0. Hence, just = {} is sufficient for
> arrays and will hopefully compile to the same code as an explicit
> memset().

Oh, nice. You are right, indeed. I didn't know that.

-- 
Greetings, Michael.
