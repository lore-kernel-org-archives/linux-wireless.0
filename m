Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbXLCVXf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 16:23:35 -0500
Subject: Re: [PATCH] less eventcause shifts
From: Dan Williams <dcbw@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
In-Reply-To: <1196714939.13978.171.camel@pmac.infradead.org>
References: <200711280915.11300.hs4233@mail.mn-solutions.de>
	 <1196704681.21151.13.camel@localhost.localdomain>
	 <1196714939.13978.171.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Mon, 03 Dec 2007 16:17:19 -0500
Message-Id: <1196716639.31607.11.camel@localhost.localdomain> (sfid-20071203_212342_092025_DA3B1A80)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-12-03 at 20:48 +0000, David Woodhouse wrote:
> On Mon, 2007-12-03 at 12:58 -0500, Dan Williams wrote:
> > I'm sort of sitting on these patches until you and Woodhouse start using
> > the same git tree until he's done with the command rework...  It's going
> > to be near impossible to handle both of your patches with any certainty.
> > Any progress on whether you've both been able to work in the same repo?
> 
> http://git.infradead.org/?p=libertas-2.6.git
> 
> It's based on Linus' tree -- we've abandoned John's wireless-dev tree
> altogether. He rebases it and uses branches -- it's just an exercise in
> making git hard.

Then you of course understand that you may have a bitch of a time
getting it back to John.  Because you can't just go to Linus, you need
to go through John when you want to upstream stuff.  That's how it
works.

However, since Libertas is fullmac-ish, the merge probably won't be
horrible.

Dan


