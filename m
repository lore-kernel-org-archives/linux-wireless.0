Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4041 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423AbYAWNCs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 08:02:48 -0500
Date: Wed, 23 Jan 2008 07:46:39 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Stefano Brivio <stefano.brivio@polimi.it>, davem@davemloft.net,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless-2.6 'upstream' 2008-01-22
Message-ID: <20080123124639.GB3157@tuxdriver.com> (sfid-20080123_130252_375088_B98F6ED5)
References: <20080123014521.GG3206@tuxdriver.com> <20080123121551.4586e706@morte> <200801231230.07734.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200801231230.07734.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 23, 2008 at 12:30:07PM +0100, Michael Buesch wrote:
> On Wednesday 23 January 2008 12:15:51 Stefano Brivio wrote:
> > On Tue, 22 Jan 2008 20:45:21 -0500
> > "John W. Linville" <linville@tuxdriver.com> wrote:
> > 
> > >       b43legacy: Remove the PHY spinlock
> > 
> > I hope you tested this. I still haven't been able to (I received the
> > needed hardware yesterday), and Michael said that the patch has been
> > compile-tested only.
> 
> John, if we use subject lines such as:
> 
> [PATCH RFT] foobar: bizbaz
> 
> That means the patch is _not_ submitted for inclusion, yet.
> The RFT means Request-For-Testing. Ususally, if I send out such

Thanks, I'm well aware.

Larry said he tested it, two weeks ago.  No one contradicted it.
And time is short for new development for 2.6.25 -- but there is
plenty of time for fixes. :-)

> For this particular patch, please leave it in now. I'm pretty
> sure it is correct. So actual testing will be done upstream now. ;)

Exactly.

John
-- 
John W. Linville
linville@tuxdriver.com
