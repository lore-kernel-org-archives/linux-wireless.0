Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55988 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761088AbXGKUVQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2007 16:21:16 -0400
Date: Wed, 11 Jul 2007 21:20:35 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/14] major mac80211 restructuring/cleanups
Message-ID: <20070711202035.GA15457@infradead.org>
References: <20070621221603.778432000@sipsolutions.net> <20070710153456.471e395e@logostar.upir.cz> <1184075439.15565.11.camel@johannes.berg> <20070710162912.17899683@logostar.upir.cz> <1184079079.15565.13.camel@johannes.berg> <20070710171216.GE7927@tuxdriver.com> <1184092500.3738.15.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1184092500.3738.15.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 10, 2007 at 08:35:00PM +0200, Johannes Berg wrote:
> I don't really see the big problem anyhow. As long as we don't want any
> patches in upstream that depend on the refactoring we can delay pushing
> the refactoring upstream. Once we do get patches we can decide to either
> make two versions of them or at some point push the refactoring upstream
> as well; problems will only arise if we delay too much pushing patches
> upstream that are before the refactoring, those would need to be
> rediffed.

The normal Linux aproach is to push the refactoring as soon as possible.
That way the other changes have to be rebased once and than you're done
with it.  If you keep the big refactoring in some staging tree porting
things forth and back will be an endless pain.

