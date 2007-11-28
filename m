Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:46574 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759302AbXK1Q3a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 11:29:30 -0500
Subject: Re: [PATCH] less eventcause shifts
From: David Woodhouse <dwmw2@infradead.org>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
In-Reply-To: <200711281613.51463.hs4233@mail.mn-solutions.de>
References: <200711280915.11300.hs4233@mail.mn-solutions.de>
	 <1196261611.28264.0.camel@localhost.localdomain>
	 <1196262129.30806.26.camel@pmac.infradead.org>
	 <200711281613.51463.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 28 Nov 2007 16:29:25 +0000
Message-Id: <1196267365.30806.40.camel@pmac.infradead.org> (sfid-20071128_162933_538022_464E0584)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 2007-11-28 at 16:13 +0100, Holger Schurig wrote:
> > s/less/fewer/ of course :)
> 
> Thanks. Should I re-submit?

Well, if we're going to put up a git tree, you could just fix it when
you commit to that.

I've just pushed a couple of preliminary patches to
git://git.infradead.org/libertas-2.6.git, which is based on the
'everything' branch (I wish people wouldn't use branches) of
wireless-2.6.git

Let me have a SSH public key and I'll give you an account with access to
that tree.

> In what parts of libertas are you working?

Rewriting the command submission and queueing code.

I could do with getting hold of SD and CF devices -- any hints on where
to find them?

-- 
dwmw2

