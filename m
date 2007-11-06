Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2086 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181AbXKFBRP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2007 20:17:15 -0500
Date: Mon, 5 Nov 2007 20:16:07 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] move wlan_*_association_work from header to c file
Message-ID: <20071106011607.GA23747@tuxdriver.com> (sfid-20071106_011717_068642_5D696534)
References: <200710111151.06989.hs4233@mail.mn-solutions.de> <1193073620.4325.7.camel@localhost.localdomain> <200710251037.50057.hs4233@mail.mn-solutions.de> <200710261343.51684.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200710261343.51684.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 26, 2007 at 01:43:51PM +0200, Holger Schurig wrote:
> Hi John !
> 
> wireless-2.6/everything is a moving target. The two patches I've 
> sent yesterday no longer apply cleanly. So I've made them new.
> 
> Because of the sheer size of one of them, I've put them there:
> 
> http://git.infradead.org/?p=users/schurig/libertas-cleanup.git;a=shortlog;h=cleanup
> 
> 
> Please apply.

The 2nd patch "libertas: move to uniform lbs_/LBS_ namespace" breaks
the compile of if_sdio.c, so I had to drop it.  I dropped "libertas:
clean up association debug messages" as well.

John
-- 
John W. Linville
linville@tuxdriver.com
