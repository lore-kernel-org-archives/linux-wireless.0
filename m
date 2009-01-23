Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35345 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbZAWUBg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 15:01:36 -0500
Subject: Re: [PATCH 0/7] airo: cleanups and simplifications
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090123194010.GD30486@tuxdriver.com>
References: <1232462691.22158.6.camel@localhost.localdomain>
	 <20090123194010.GD30486@tuxdriver.com>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 14:59:52 -0500
Message-Id: <1232740792.2577.49.camel@localhost.localdomain> (sfid-20090123_210150_447266_6CB96E45)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-01-23 at 14:40 -0500, John W. Linville wrote:
> On Tue, Jan 20, 2009 at 09:44:51AM -0500, Dan Williams wrote:
> > airo needs some hot sexy love.  come and get your love come and get your
> > love now.
> > 
> > [PATCH 1/7] airo: clean up and clarify interrupt-time task handling
> > [PATCH 2/7] airo: re-arrange WPA capability checks
> > [PATCH 3/7] airo: simplify WEP index and capability checks
> > [PATCH 4/7] airo: clean up WEP key operations
> > [PATCH 5/7] airo: use __attribute__ ((packed)) not #pragma
> > [PATCH 6/7] airo: clean up and clarify micinit()
> > [PATCH 7/7] airo: remove useless #defines
> 
> 1-4 (v2 of #4) don't seem to apply to wireless-testing anymore.  #1 in
> particular was a big reject, so I didn't try too hard on the rest.
> I'll drop 5-7 too just in case there are dependencies.
> 
> Would you mind rebasing and reposting?

Will do.

Dan


