Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:37935 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbYEHNA1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 09:00:27 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] mac80211: rewrite fragmentation code
Date: Thu, 8 May 2008 15:00:00 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
References: <20080430124055.091382000@sipsolutions.net> <200805071548.06693.mb@bu3sch.de> <20080508032208.GA401@gondor.apana.org.au>
In-Reply-To: <20080508032208.GA401@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805081500.00682.mb@bu3sch.de> (sfid-20080508_145927_295999_6E95A749)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 08 May 2008 05:22:08 Herbert Xu wrote:
> On Wed, May 07, 2008 at 03:48:06PM +0200, Michael Buesch wrote:
> >
> > So there's no way to actually fail in a TX handler? Drivers
> > are doomed to drop the packet, if they cannot handle it due to
> > ring overflow?
> 
> You're supposed to stop the queue before the ring overflows.

Ok, what about DMA error. kmalloc error or something else?
ring overflow was a bad example, of course.

-- 
Greetings Michael.
