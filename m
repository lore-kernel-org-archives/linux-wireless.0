Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57915
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751775AbZFJAtu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 20:49:50 -0400
Date: Tue, 09 Jun 2009 17:49:52 -0700 (PDT)
Message-Id: <20090609.174952.40068461.davem@davemloft.net>
To: johannes@sipsolutions.net
Cc: linville@tuxdriver.com, sfr@canb.auug.org.au,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rfkill: include err.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <1244555812.4672.9.camel@johannes.local>
References: <1244555812.4672.9.camel@johannes.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 09 Jun 2009 15:56:52 +0200

> Since we use ERR_PTR and similar macros, we need to include linux/err.h.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

I'm applying this directly to net-next-2.6 to fix the -next
build.

Please submit the more critical build fixes for regressions
introduced by the wireless tree direclty to me in the future
thanks.
