Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbXLKEcP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 23:32:15 -0500
Subject: Re: [RFC PATCH] introduce WEXT scan capabilities
From: Dan Williams <dcbw@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: jt@hpl.hp.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
In-Reply-To: <20071210.161144.190139513.davem@davemloft.net>
References: <1197223174.9149.60.camel@localhost.localdomain>
	 <20071209.221048.187424680.davem@davemloft.net>
	 <1197307403.18585.10.camel@localhost.localdomain>
	 <20071210.161144.190139513.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 10 Dec 2007 23:22:10 -0500
Message-Id: <1197346930.16807.7.camel@localhost.localdomain> (sfid-20071211_043223_894102_818D2A43)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-12-10 at 16:11 -0800, David Miller wrote:
> From: Dan Williams <dcbw@redhat.com>
> Date: Mon, 10 Dec 2007 12:23:23 -0500
> 
> > Is this an unconditional NAK for any changes to WEXT?
> 
> Well, it is at least completely proven that you cannot
> extend the structures without crapping all over random
> areas of the stack space of the user application.
> 
> So at a minimum you're going to get NAKs for any patch
> that does things that way.

So would another WEXT subcommand be acceptable to you?

Dan


