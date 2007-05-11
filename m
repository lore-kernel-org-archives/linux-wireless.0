Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757563AbXEKDKd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 23:10:33 -0400
Subject: Re: libertas driver
From: Dan Williams <dcbw@redhat.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4643D3FC.9070308@garzik.org>
References: <20070510181416.8637b466.akpm@linux-foundation.org>
	 <4643D3FC.9070308@garzik.org>
Content-Type: text/plain
Date: Thu, 10 May 2007 23:14:24 -0400
Message-Id: <1178853264.8607.61.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-05-10 at 22:25 -0400, Jeff Garzik wrote:
> Andrew Morton wrote:
> > x86_64 build is a bit ugly.
> 
> Not sure what happened to his mailer (patch #0 of 19 appeared), but:
> http://people.redhat.com/dcbw/libertas-patches/
> 
> Patches 18 and 19 address several of these.

16, 18, and 19 should take care of all the issues I (and Randy) found by
sparse and building on x86-64.

Thanks,
Dan


