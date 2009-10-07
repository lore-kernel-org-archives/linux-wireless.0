Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933895AbZJGSMy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 14:12:54 -0400
Subject: Re: linux-next: Tree for October 7 (libertas build failure)
From: Dan Williams <dcbw@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-wireless@vger.kernel.org, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	libertas-dev@lists.infradead.org,
	Holger Schurig <hs4233@mail.mn-solutions.de>
In-Reply-To: <20091007105210.409a1991.randy.dunlap@oracle.com>
References: <20091007173517.abfcfa2a.sfr@canb.auug.org.au>
	 <20091007105210.409a1991.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Wed, 07 Oct 2009 11:12:00 -0700
Message-Id: <1254939120.16001.45.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-10-07 at 10:52 -0700, Randy Dunlap wrote:
> On Wed, 7 Oct 2009 17:35:17 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20091006:
> 
> 
> drivers/built-in.o: In function `lbs_cfg_free':
> (.text+0x3479e0): undefined reference to `wiphy_unregister'
> drivers/built-in.o: In function `lbs_cfg_free':
> (.text+0x3479e7): undefined reference to `wiphy_free'
> drivers/built-in.o: In function `lbs_cfg_register':
> (.text+0x347a52): undefined reference to `wiphy_register'
> drivers/built-in.o: In function `lbs_cfg_alloc':
> (.text+0x347acf): undefined reference to `wiphy_new'

Holger, perhaps we need some Kconfig updates to select cfg80211?

Dan


