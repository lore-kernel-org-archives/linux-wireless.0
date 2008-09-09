Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39613 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbYIIOZe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 10:25:34 -0400
Date: Tue, 9 Sep 2008 10:05:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org
Subject: Re: wireless-testing rebased again?
Message-ID: <20080909140556.GA4291@tuxdriver.com> (sfid-20080909_162539_653638_5B274A48)
References: <1220858698.28282.324.camel@debian.sh.intel.com> <20080908142117.GA24557@tuxdriver.com> <873ak9hnux.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <873ak9hnux.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 09, 2008 at 08:47:34AM +0300, Kalle Valo wrote:
> John W. Linville <linville@tuxdriver.com> writes:
> 
> > On Mon, Sep 08, 2008 at 03:24:58PM +0800, Zhu Yi wrote:
> >
> >> I find the wireless-testing GIT has been rebased twice in less than one
> >> month. Does it mean you give up making it a long lived merge-able tree?
> >> This may affect to the downstream wireless drivers code management. At
> >> least for iwlwifi, we'd expect to merge with wireless-testing everytime.
> >
> > There must be some mistake, it has not been rebased at all -- at
> > least not as far as git is concerned.  I have done my now customary
> > "revert everything, pull from Linus re-apply" thing that I call a
> > virtual rebase, but the history has remained continuous.
> >
> > The non-master branches do get rebased of course.  Perhaps you saw
> > that and thought that master had been rebased as well?
> 
> FWIW, I also have had conflicts while pulling wireless-testing#master
> and I similarly thought that you have rebased it. But if you didn't I
> don't know what happened.

It is possible that I mistakenly copied the wrong tree out there or
something like that -- it has happened occasionally.  Generally I know
when I've done that and correct it immediately, but it is possible
that it happened and the wrong tree was sitting under wireless-testing
for a day or two.  If so, then I apologize.

John
