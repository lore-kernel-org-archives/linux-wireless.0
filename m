Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbXJOOm4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 10:42:56 -0400
Subject: Re: [PATCH] move wlan_*_association_work from header to c file
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <200710151628.43425.hs4233@mail.mn-solutions.de>
References: <200710111151.06989.hs4233@mail.mn-solutions.de>
	 <200710150918.02708.hs4233@mail.mn-solutions.de>
	 <1192457588.12009.5.camel@localhost.localdomain>
	 <200710151628.43425.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Mon, 15 Oct 2007 10:42:32 -0400
Message-Id: <1192459352.12009.25.camel@localhost.localdomain> (sfid-20071015_154259_626458_8E32D1A4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-10-15 at 16:28 +0200, Holger Schurig wrote:
> Hi Dan !
> 
> > I don't really care.  You've already done the work for 'lbs'
> > so that's fine by me.
> 
> Yeah, but doing something like
> 
>    perl -pi -e 's:lbs_:lts_:g' XXXX.patch
> 
> would be easy enought.
> 
> 
> 
> Did already look at
> 
> http://git.infradead.org/?p=users/schurig/libertas-cleanup.git;a=commitdiff;h=aff223229493c7c43c8acedc728cdb312f82f3f9
> 
> ????   Please review :-)

Yeah, I got through maybe 1/3 of it so far, it's huge :)  I don't have
one of my libertas parts to test with me right now, but I'll try to do
that today or tomorrow.  I'd like to just run through a few scenarios to
make sure.  I assume you've been running it for a few days or so?

Dan


