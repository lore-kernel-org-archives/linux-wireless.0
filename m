Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4624 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755281AbYAaREe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2008 12:04:34 -0500
Date: Thu, 31 Jan 2008 11:39:40 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>,
	libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH, take 3] libertas: clean up association debug messages
Message-ID: <20080131163940.GD6413@tuxdriver.com> (sfid-20080131_170437_131752_2BC83BBB)
References: <200710151255.56358.hs4233@mail.mn-solutions.de> <1201665912.28377.38.camel@shinybook.infradead.org> <200801300854.38715.hs4233@mail.mn-solutions.de> <200801301110.55581.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200801301110.55581.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 30, 2008 at 11:10:55AM +0100, Holger Schurig wrote:
> > John, I saw that you pushed one bugfix patch upstream, but not
> > the others. Please don't apply them, I'll put all ACKed
> > patches into the libertas-2.6 tree instead.
> 
> Hmm, I see that he already applied them to 
> wireless-2.6/everything.

Only these were sent to davem:

Holger Schurig (1):
      libertas: fix interrupt while removing driver

Ihar Hrachyshka (1):
      libertas: fix memory alignment problems on the blackfin

The others haven't been sent anywhere yet.  If you would like I'll be happy
to revert them and wait for dwmw2's series.

John
-- 
John W. Linville
linville@tuxdriver.com
