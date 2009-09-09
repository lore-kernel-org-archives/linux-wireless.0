Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:63038 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752012AbZIIRTO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 13:19:14 -0400
From: Frans Pop <elendil@planet.nl>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: iwlagn: order 2 page allocation failures
Date: Wed, 9 Sep 2009 19:19:12 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Andrew Morton <akpm@linux-foundation.org>,
	cl@linux-foundation.org, Assaf Krauss <assaf.krauss@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Mohamed Abbas <mohamed.abbas@intel.com>
References: <200909060941.01810.elendil@planet.nl> <200909091759.33655.elendil@planet.nl> <20090909165545.GK24614@csn.ul.ie>
In-Reply-To: <20090909165545.GK24614@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200909091919.16461.elendil@planet.nl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 09 September 2009, you wrote:
> The problem with this theory is that the patches have been in since Nov
> 2008 but reports are only showing up now.  Frans, how sure are you that
> this is a recent problem? Is it readily reproducible?

The only thing I can say here is that I've never seen the issue before 
(and thanks to logcheck I certainly would have).
The laptop is in constant use, but I rarely stress the memory like that. 
Swap is almost always at 0.

I would have to make an effort to try and reproduce it, probably by again 
creating some very large images and loading those in konqueror, maybe 
while streaming a movie over wireless or something.

Thanks for your efforts,
FJP
