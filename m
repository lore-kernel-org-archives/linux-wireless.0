Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbXLGSFN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 13:05:13 -0500
Subject: Re: [PATCH] libertas: implement new scanning logic
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200712071547.37944.hs4233@mail.mn-solutions.de>
References: <200711290927.15915.hs4233@mail.mn-solutions.de>
	 <1196787130.4772.2.camel@localhost.localdomain>
	 <200712071547.37944.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Fri, 07 Dec 2007 12:57:43 -0500
Message-Id: <1197050263.30465.7.camel@localhost.localdomain> (sfid-20071207_180519_021917_BCA724D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-12-07 at 15:47 +0100, Holger Schurig wrote:
> > So I tested this one, not the one from libertas-dev (which was
> > posted a day earlier).  And this one seems fine.  Ack for
> > commit to libertas-2.6.
> >
> > Would you like me to confirm on SDIO?
> 
> I now commit that to libertas-2.6, even without your 
> SDIO-testing.

Yeah, go ahead.  I got distracted because of changes in > 2.6.23 kernels
that cause the driver not to build there, and haven't chased them down
yet.

Dan


