Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:15655 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbXGQN5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2007 09:57:32 -0400
Received: by py-out-1112.google.com with SMTP id d32so2907546pye
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jul 2007 06:57:31 -0700 (PDT)
Message-ID: <43e72e890707170657w367ac696nb4a4b1d437162091@mail.gmail.com>
Date: Tue, 17 Jul 2007 09:57:30 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH 00/14] major mac80211 restructuring/cleanups
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Jiri Benc" <jbenc@suse.cz>, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890707170654h7ecb9ffhb609db23e9c98faa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <20070621221603.778432000@sipsolutions.net>
	 <20070710153456.471e395e@logostar.upir.cz>
	 <1184075439.15565.11.camel@johannes.berg>
	 <20070710162912.17899683@logostar.upir.cz>
	 <1184079079.15565.13.camel@johannes.berg>
	 <20070710171216.GE7927@tuxdriver.com>
	 <1184092500.3738.15.camel@johannes.berg>
	 <20070711202035.GA15457@infradead.org>
	 <43e72e890707170654h7ecb9ffhb609db23e9c98faa@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/17/07, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On 7/11/07, Christoph Hellwig <hch@infradead.org> wrote:
> > On Tue, Jul 10, 2007 at 08:35:00PM +0200, Johannes Berg wrote:
> > > I don't really see the big problem anyhow. As long as we don't want any
> > > patches in upstream that depend on the refactoring we can delay pushing
> > > the refactoring upstream. Once we do get patches we can decide to either
> > > make two versions of them or at some point push the refactoring upstream
> > > as well; problems will only arise if we delay too much pushing patches
> > > upstream that are before the refactoring, those would need to be
> > > rediffed.
> >
> > The normal Linux aproach is to push the refactoring as soon as possible.
> > That way the other changes have to be rebased once and than you're done
> > with it.  If you keep the big refactoring in some staging tree porting
> > things forth and back will be an endless pain.
>
> This is true but the idea is to try to merge wireless-dev into
> wireless-2.6 ASAP. We shouldn't stop wireless-dev tree changes as that
> is what we need to help with development. I can only see this helping
> us down the road. Jiri -- are you sure? :)

Nevermind... Johannes' patches won't apply anymore, except for the
ones he pinged about for recently...

  Luis
