Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:56351 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756763AbZDURkL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 13:40:11 -0400
Date: Tue, 21 Apr 2009 17:39:48 +0000
From: Chris Wright <chrisw@sous-sol.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Philip Rakity <prakity@yahoo.com>, linux-wireless@vger.kernel.org,
	stable@kernel.org, libertas-dev@lists.infradead.org
Subject: Re: [stable] [PATCH] libertas: don't leak skb on receive error
Message-ID: <20090421173948.GC22386@hera.kernel.org> (sfid-20090421_194044_306505_2996A5D6)
References: <422915.71719.qm@web58908.mail.re1.yahoo.com> <1239200582.14879.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1239200582.14879.5.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Dan Williams (dcbw@redhat.com) wrote:
> On Tue, 2009-04-07 at 12:41 -0700, Philip Rakity wrote:
> > 
> > Don't lead memory when receive errors 
> > Signed-off-by: Philip Rakity <prakity@yahoo.com>
> 
> Acked-by: Dan Williams <dcbw@redhat.com>

Doesn't look like this is upstream yet.  Please send to
stable@kernel.org when it is.

thanks,
-chris
