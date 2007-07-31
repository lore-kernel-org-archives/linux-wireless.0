Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:43185
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761400AbXGaSQo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:16:44 -0400
From: Michael Buesch <mb@bu3sch.de>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] softmac: Fix deadlock of wx_set_essid with assoc work
Date: Tue, 31 Jul 2007 20:16:30 +0200
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <200707311457.33723.mb@bu3sch.de> <1185894060.3083.115.camel@pmac.infradead.org>
In-Reply-To: <1185894060.3083.115.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200707312016.31054.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 31 July 2007 17:01:00 David Woodhouse wrote:
> On Tue, 2007-07-31 at 14:57 +0200, Michael Buesch wrote:
> > The essid wireless extension does deadlock against the assoc mutex,
> > as we don't unlock the assoc mutex.
> > 
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> > 
> > --
> > 
> > David, please test if this fixes your deadlock. 
> 
> Seems to, although I'll have to leave it a few more hours before I'm
> sure. Thanks.

Ok, this is a deadlock, anyway. Even if it's not "your" deadlock. :)
So I'll build a correct patch for this (this was an incomplete
hack) and submit it.

-- 
Greetings Michael.
