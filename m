Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59717 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758183AbZKDVaI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 16:30:08 -0500
Date: Wed, 4 Nov 2009 16:16:00 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	stern@rowland.harvard.edu, davem@davemloft.net
Subject: Re: [PATCH] libertas if_usb: Fix crash on 64-bit machines
Message-ID: <20091104211600.GE10786@tuxdriver.com>
References: <1256924714.4030.44.camel@macbook.infradead.org> <200910301944.14740.chunkeey@googlemail.com> <1256928681.4030.112.camel@macbook.infradead.org> <200910302026.47131.chunkeey@googlemail.com> <20091104191642.GB10786@tuxdriver.com> <1257363418.22822.28.camel@macbook.infradead.org> <1257364903.14545.51.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1257364903.14545.51.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 04, 2009 at 12:01:43PM -0800, Dan Williams wrote:
> On Wed, 2009-11-04 at 19:36 +0000, David Woodhouse wrote:
> > On Wed, 2009-11-04 at 14:16 -0500, John W. Linville wrote:
> > > Is anyone evaluating these suggestions?  Should I be expecting
> > > properly formatted patch emails? 
> > 
> > The suggestions make sense, but not for stable. Let's fix the crasher
> > bug first, and worry about the rest later.
> 
> Sounds good to me...

Yes, of course.

So, Christian, will you be following-up?

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
