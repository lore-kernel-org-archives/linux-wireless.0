Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42133 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593AbZEZNd2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 09:33:28 -0400
Subject: Re: [PATCH v11] rfkill: rewrite
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Will Keaney <keaneyw@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090526131533.GA3932@tuxdriver.com>
References: <1242942720.4212.19.camel@johannes.local>
	 <1243068246.4606.45.camel@johannes.local> <4A1BDE51.7020009@gmail.com>
	 <20090526131533.GA3932@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 26 May 2009 09:32:43 -0400
Message-Id: <1243344763.2575.3.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-05-26 at 15:15 +0200, John W. Linville wrote:
> On Tue, May 26, 2009 at 08:19:29AM -0400, Will Keaney wrote:
> > Johannes Berg wrote:
> > > This patch completely rewrites the rfkill core to address
> > > the following deficiencies:
> > >   
> > I applied this to a fresh pull of wireless-testing this morning, and
> > haven't had any problems from it.  It looks like the soft lockup I
> > reported earlier has been fixed.
> 
> Cool, thanks for the report.
> 
> I'm leaning towards merging this in time for the 2.6.31 merge
> window...who wants to complain? :-)

Merge it!

Dan


