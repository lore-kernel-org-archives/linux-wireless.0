Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38385 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943AbZE0IPa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 04:15:30 -0400
Date: Wed, 27 May 2009 10:07:38 +0200
From: "John W. Linville" <linville@tuxdriver.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Will Keaney <keaneyw@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v11] rfkill: rewrite
Message-ID: <20090527080737.GB8134@tuxdriver.com>
References: <1242942720.4212.19.camel@johannes.local> <1243068246.4606.45.camel@johannes.local> <4A1BDE51.7020009@gmail.com> <20090526131533.GA3932@tuxdriver.com> <20090527025516.GC22235@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090527025516.GC22235@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 26, 2009 at 11:55:16PM -0300, Henrique de Moraes Holschuh wrote:
> On Tue, 26 May 2009, John W. Linville wrote:
> > On Tue, May 26, 2009 at 08:19:29AM -0400, Will Keaney wrote:
> > > Johannes Berg wrote:
> > > > This patch completely rewrites the rfkill core to address
> > > > the following deficiencies:
> > > >   
> > > I applied this to a fresh pull of wireless-testing this morning, and
> > > haven't had any problems from it.  It looks like the soft lockup I
> > > reported earlier has been fixed.
> > 
> > Cool, thanks for the report.
> > 
> > I'm leaning towards merging this in time for the 2.6.31 merge
> > window...who wants to complain? :-)
> 
> As long as the missing userspace control functionality (the lack of which is
> a _serious_ regression for platform drivers) is added before 2.6.31 ships, I
> have no complains.
> 
> Userspace must be able to change the (soft) state using sysfs.  This is
> not an optional part of rfkill :-)

Are there any apps that actually use this feature?  It seems like
that even if there are apps, they need to handle drivers that don't
support it.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
