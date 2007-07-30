Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:48789 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763715AbXG3UKK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2007 16:10:10 -0400
Date: Mon, 30 Jul 2007 13:13:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/5] Use mutex instead of semaphore in the Host AP  driver
Message-Id: <20070730131302.82622b06.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.0.999.0707310142190.17287@enigma.security.iitk.ac.in>
References: <20070729212909.GC3432@traven>
	<20070729213434.GD3432@traven>
	<200707300006.42397.mb@bu3sch.de>
	<alpine.LFD.0.999.0707300842350.10861@enigma.security.iitk.ac.in>
	<alpine.LFD.0.999.0707300904360.10861@enigma.security.iitk.ac.in>
	<20070730054004.GI3432@traven>
	<alpine.LFD.0.999.0707301247100.12730@enigma.security.iitk.ac.in>
	<20070730145005.GB6586@tuxdriver.com>
	<alpine.LFD.0.999.0707310142190.17287@enigma.security.iitk.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 31 Jul 2007 01:44:37 +0530 (IST) Satyam Sharma wrote:

> 
> 
> On Mon, 30 Jul 2007, John W. Linville wrote:
> 
> > On Mon, Jul 30, 2007 at 12:50:31PM +0530, Satyam Sharma wrote:
> > > On Mon, 30 Jul 2007, Matthias Kaehlcke wrote:
> > > 
> > > > [...]
> > > > The Host AP driver uses a semaphore as mutex. Use the mutex API
> > > > instead of the (binary) semaphore.
> > > > 
> > > > Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
> > > 
> > > Reviewed-by: Satyam Sharma <satyam@infradead.org>
> > 
> > Is that the same as Acked-by?  Or do you disagree with the patch?
> > 
> > Just checkin'...
> 
> Well, I'm not the maintainer, so didn't think correct to give an
> "Acked-by". "Reviewed-by" generally means I read the patch, and think
> it is correct. Probably could save time for others ...

You should use Acked-by.  See Documentation/SubmittingPatches.  :)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
