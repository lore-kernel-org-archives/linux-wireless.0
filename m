Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756511AbXJYN5U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 09:57:20 -0400
Subject: Re: [PATCH] move wlan_*_association_work from header to c file
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <200710251037.50057.hs4233@mail.mn-solutions.de>
References: <200710111151.06989.hs4233@mail.mn-solutions.de>
	 <1192466593.15225.28.camel@localhost.localdomain>
	 <1193073620.4325.7.camel@localhost.localdomain>
	 <200710251037.50057.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Thu, 25 Oct 2007 09:55:01 -0400
Message-Id: <1193320501.5542.13.camel@localhost.localdomain> (sfid-20071025_145725_741632_8359BE88)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-10-25 at 10:37 +0200, Holger Schurig wrote:
> Hi John,
> 
> I've put both patches that Dan acknowledged with
> 
> > I ran the driver for a while and nothing appears to have
> > regressed horribly from light testing a few large transfers. 
> > Seems OK to push into 2.6.25 to me.
> 
> and
> 
> > > In passing, rename the functions to libertas_XXX.
> > > 
> > > Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
> >
> > Acked-by: Dan Williams <dcbw@redhat.com>
> 
> onto
> 
>   http://git.infradead.org/?p=users/schurig/libertas-cleanup.git;a=summary
> 
> or
> 
>   git://git.infradead.org/users/schurig/libertas-cleanup.git
> 
> 
> (The rename patch is so huge). Please apply.

Acked-by: Dan Williams <dcbw@redhat.com>

Thanks for fixing the two ABI things.  John, can you pull into whatever
you're targetting for 2.6.25?

Thanks,
Dan


