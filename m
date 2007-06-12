Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3566 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176AbXFLOYn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 10:24:43 -0400
Date: Tue, 12 Jun 2007 10:05:29 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
Subject: Re: Please pull libertas-2.6
Message-ID: <20070612140529.GD310@tuxdriver.com>
References: <1181102122.18061.8.camel@xo-28-0B-88.localdomain> <200706120843.48517.hs4233@mail.mn-solutions.de> <1181649582.17599.4.camel@xo-28-0B-88.localdomain> <200706121519.09758.hs4233@mail.mn-solutions.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200706121519.09758.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 12, 2007 at 03:19:09PM +0200, Holger Schurig wrote:
> > Well; I'm going to commit that one really soon to
> > libertas-2.6, but I don't think it's 2.6.22 material mainly
> > because there's no code for CF cards in libertas-2.6 yet
> > anyway...
> 
> Right, it's not 2.6.22 material. That's why I asked for inclusion 
> in libertas-2.6 once I heard that you & Linville are 
> cherry-picking bugfixes.
> 
> 
> But I hope to be far enought so that the driver (marked 
> EXPERIMENTAL) works so that I can submit it to 2.6.23.
> 
> I just fear that the merge-window for 2.6.23 opens too early for 
> me :-)

FWIW, waiting for the merge window is generally frowned upon.  If at
all possible you should submit patches now or ASAP so that Jeff and
I have a reasonable chance to review them and they can make their
way into -mm for some testing BEFORE the merge window opens.

Hth!

John
-- 
John W. Linville
linville@tuxdriver.com
