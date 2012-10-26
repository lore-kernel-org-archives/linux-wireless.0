Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59992 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966544Ab2JZVQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 17:16:08 -0400
Date: Fri, 26 Oct 2012 17:03:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] carl9170: fix spurious transmissions in sniffer mode
Message-ID: <20121026210348.GA25691@tuxdriver.com> (sfid-20121026_231614_900310_8C4BA5B8)
References: <201209112318.35334.chunkeey@googlemail.com>
 <201210131059.53325.chunkeey@googlemail.com>
 <201210262007.17369.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201210262007.17369.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 26, 2012 at 08:07:16PM +0200, Christian Lamparter wrote:
> On Saturday 13 October 2012 10:59:53 Christian Lamparter wrote:
> > On Tuesday 11 September 2012 23:18:34 Christian Lamparter wrote:
> > > Several people have complained about an unusual
> > > and undocumented feature of the AR9170 hardware:
> > > 
> > > In siffer mode, the hardware generates spurious
> > > ACK frames for every received frame... even
> > > broadcasts.
> > > 
> > > The reason for this malfunction is unknown:
> > > <http://marc.info/?l=linux-wireless&m=134517238506033>
> > > But there's a workaround: Instead of the special
> > > sniffer mode, the hardware will be put into
> > > station mode and all rx filters are disabled.
> > > 
> > > Reported-by: Johannes Berg <johannes@sipsolutions.net>
> > > Reported-by: Marco Fonseca <marco@tampabay.rr.com>
> > > Reported-by: Janusz Dziedzic <janusz.dziedzic@gmail.com>
> > > Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> > > ---
> > John,
> > 
> > Do you have doubts about this patch, or is there a problem 
> > that I don't know about?
> 
> John,
> 
> can you comment? Or do you need a resend? Or should I stop
> asking about it ;)?
> 
> Regards,
> 	Chr

It looks fine.  There was a lot of comments in the original thread,
which probably explains why I've been overlooking it.  I'll try to
include it when I get back to merging for -next (soon).

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
