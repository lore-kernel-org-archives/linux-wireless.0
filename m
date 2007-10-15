Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108AbXJOONb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 10:13:31 -0400
Subject: Re: [PATCH] move wlan_*_association_work from header to c file
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <200710150918.02708.hs4233@mail.mn-solutions.de>
References: <200710111151.06989.hs4233@mail.mn-solutions.de>
	 <20071011141642.GA6976@infradead.org>
	 <1192114234.31895.5.camel@localhost.localdomain>
	 <200710150918.02708.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Mon, 15 Oct 2007 10:13:08 -0400
Message-Id: <1192457588.12009.5.camel@localhost.localdomain> (sfid-20071015_151333_367807_3C7EF42E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-10-15 at 09:18 +0200, Holger Schurig wrote:
> > wlan_set_essid -> lts_set_essid
> > wlan_private -> lts_private
> >
> > (I don't really like 'lbs' personally but I'm not that
> > strongly against it)
> 
> I've used lbs_XXX and LBS_DEB_xxx for the debugging stuff. Do you 
> want to get that changed to lts_XXX and LTS_DEB_xxx, too?
> 
> (I personally like lbs more, but am also not strongly for it or 
> against something else, I just want to keep things orthogonal)

I don't really care.  You've already done the work for 'lbs' so that's
fine by me.

Dan


