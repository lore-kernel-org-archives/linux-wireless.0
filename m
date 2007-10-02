Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:45445
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbXJBUm2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2007 16:42:28 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Daniel Drake <dsd@gentoo.org>
Subject: Re: What happened with z1211?
Date: Tue, 2 Oct 2007 22:39:09 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200710021147.55506.mb@bu3sch.de> <470272CE.60405@gentoo.org>
In-Reply-To: <470272CE.60405@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710022239.09217.mb@bu3sch.de> (sfid-20071002_214232_538612_440E1CD8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 02 October 2007 18:33:18 Daniel Drake wrote:
> Michael Buesch wrote:
> > Hi John,
> > 
> > What happened with the z1211 driver in wireless-2.6?
> > It's not there anymore. There's only the old zd1211rw
> > and zd1211rw-mac80211 stuff. Did you rename it again?
> 
> We aren't going to rename the driver, we're going to directly port 
> drivers/net/wireless/zd1211rw to mac80211 when we're ready. John has put 
> it back as zd1211rw-mac80211 for now to allow development to continue. 
> Don't use the zd1211rw-mac80211 branch though (it won't compile), 
> develop against 'everything' as usual.

When is that port going to happen then?
I mean, the drop of z1211 is a huge regression for me, as I am
using it in production environment.

-- 
Greetings Michael.
