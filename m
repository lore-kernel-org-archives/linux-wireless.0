Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:41311 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbXIXNYX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 09:24:23 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1IZnuY-0000Sq-GF
	for linux-wireless@vger.kernel.org; Mon, 24 Sep 2007 09:23:42 -0400
Subject: Re: API to regulatory control (1)
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1190639518.18521.269.camel@johannes.berg>
References: <1190456574.18521.220.camel@johannes.berg>
	 <1190638775.21374.5.camel@dv>  <20070924130715.GA18847@infradead.org>
	 <1190639518.18521.269.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 09:24:13 -0400
Message-Id: <1190640253.21374.14.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-09-24 at 15:11 +0200, Johannes Berg wrote:

> > > Please consider using "long" for hardware_value.  Drivers should be able
> > > to use this value as a pointer to some driver-specific structure.
> > 
> > If you want to use it as pointer better make it a pointer..
> 
> Then we'd have to have two values. I don't see a need for having a
> pointer at all though. Pavel, can you show a driver that really benefits
> from that? And explain why it can't use an array index here?

No, it's just a "general sanity" thing.  If we want the driver to keep
some data there without specifying what data it can be, it's better to
provide a way to keep a pointer if needed.

OK, if my suggestion doesn't sound interesting, we can forget it for
now.  After all, it's easy to change Linux code at any time, as long as
the external interfaces are not involved.

-- 
Regards,
Pavel Roskin

