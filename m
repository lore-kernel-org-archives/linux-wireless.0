Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45552 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab0BWUak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2010 15:30:40 -0500
Date: Tue, 23 Feb 2010 15:21:25 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] ath5k: remove stale function declarations, make
	some  functions static
Message-ID: <20100223202125.GE2928@tuxdriver.com>
References: <20100219012802.12460.42239.stgit@mj.roinet.com> <20100219134448.GA2844@tuxdriver.com> <1266621325.25707.14.camel@mj> <b6c5339f1002200730t46298538k30930ed52255f06e@mail.gmail.com> <1266956262.16604.1.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1266956262.16604.1.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 23, 2010 at 03:17:42PM -0500, Pavel Roskin wrote:
> On Sat, 2010-02-20 at 10:30 -0500, Bob Copeland wrote:
> > On Fri, Feb 19, 2010 at 6:15 PM, Pavel Roskin <proski@gnu.org> wrote:
> > > On Fri, 2010-02-19 at 08:44 -0500, John W. Linville wrote:
> > >> On Thu, Feb 18, 2010 at 08:28:02PM -0500, Pavel Roskin wrote:
> > >> Any reason not to just remove those functions instead of commenting
> > >> them out?
> > >
> > > I'm fine either way.  I tend to clean up more aggressively if I know
> > > that nobody will miss that code.  I wasn't sure in this case.
> > 
> > I don't think it will be a big deal if they disappear.  I think most of
> > them are just there because the original HAL had them.
> > 
> > Maybe one or two functions are waiting on an API in the stack to be useful
> > (e.g. antenna stuff), but we can always get these routines back from git
> > history if need be.
> 
> I see you are doing that work already, so please just tell me if I need
> to resubmit my patches.

Not as far as I'm concerned, but I'll probably delete those sections myself.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
