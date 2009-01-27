Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54882 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbZA0QnY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 11:43:24 -0500
Subject: Re: [PATCH 0/7 v2] airo: cleanups and simplifications
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1233047115.4012.10.camel@johannes.local>
References: <1232748914.447.2.camel@localhost.localdomain>
	 (sfid-20090123_231647_256810_FBC442D8)  <1233047115.4012.10.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 27 Jan 2009 11:41:50 -0500
Message-Id: <1233074510.25367.9.camel@localhost.localdomain> (sfid-20090127_174329_009202_B6F46950)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-01-27 at 10:05 +0100, Johannes Berg wrote:
> On Fri, 2009-01-23 at 17:15 -0500, Dan Williams wrote:
> > airo needs some hot sexy love.  come and get your love come and get your
> > love now.
> 
> Still needs some!

What are you using to generate the warnings below?  I couldn't get them
with C=2 and sparse...

Dan

> 
> +drivers/net/wireless/airo.c:3846:8: warning: symbol 'i' shadows an earlier one
> +drivers/net/wireless/airo.c:3757:6: originally declared here
> +drivers/net/wireless/airo.c:3853:8: warning: symbol 'i' shadows an earlier one
> +drivers/net/wireless/airo.c:3757:6: originally declared here
> +drivers/net/wireless/airo.c:3867:7: warning: symbol 'i' shadows an earlier one
> +drivers/net/wireless/airo.c:3757:6: originally declared here
> +drivers/net/wireless/airo.c:1315:33: warning: restricted degrades to integer
> +drivers/net/wireless/airo.c:2056:10: warning: incorrect type in assignment (different base types)
> +drivers/net/wireless/airo.c:2056:10:    expected restricted unsigned short [usertype] status
> +drivers/net/wireless/airo.c:2056:10:    got unsigned short [unsigned] [usertype] status
> +drivers/net/wireless/airo.c:2108:14: warning: incorrect type in initializer (different signedness)
> +drivers/net/wireless/airo.c:2108:14:    expected unsigned int [usertype] *fids
> +drivers/net/wireless/airo.c:2108:14:    got int *<noident>
> +drivers/net/wireless/airo.c:2132:14: warning: incorrect type in initializer (different signedness)
> +drivers/net/wireless/airo.c:2132:14:    expected unsigned int [usertype] *fids
> +drivers/net/wireless/airo.c:2132:14:    got int *<noident>
> +drivers/net/wireless/airo.c:2173:14: warning: incorrect type in initializer (different signedness)
> +drivers/net/wireless/airo.c:2173:14:    expected unsigned int [usertype] *fids
> +drivers/net/wireless/airo.c:2173:14:    got int *<noident>
> +drivers/net/wireless/airo.c:2197:14: warning: incorrect type in initializer (different signedness)
> +drivers/net/wireless/airo.c:2197:14:    expected unsigned int [usertype] *fids
> +drivers/net/wireless/airo.c:2197:14:    got int *<noident>
> +drivers/net/wireless/airo.c:3211:11: warning: cast to restricted type
> 
> johannes

