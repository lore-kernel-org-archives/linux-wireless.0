Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46942 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbbHMIyk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 04:54:40 -0400
Message-ID: <1439456078.2114.4.camel@sipsolutions.net> (sfid-20150813_105448_347679_C51DF182)
Subject: Re: [PATCH 4/4] iw:In case of memory allocation failure by
 nlmsg_alloc() cqm will pass to NLA_PUT_U32. it should not happen.
From: Johannes Berg <johannes@sipsolutions.net>
To: amit.khatri@samsung.com
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Rahul Jain <rahul.jain@samsung.com>,
	HEMANSHU SRIVASTAVA <hemanshu.s@samsung.com>,
	Nitin Jhanwar <nitin.j@samsung.com>
Date: Thu, 13 Aug 2015 10:54:38 +0200
In-Reply-To: <490671727.309651435310062683.JavaMail.weblogic@ep2mlwas06c>
References: <490671727.309651435310062683.JavaMail.weblogic@ep2mlwas06c>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-06-26 at 09:14 +0000, Amit Khatri wrote:
> Hi Johannes,
> 
> Subject: [PATCH 4/4] iw:In case of memory allocation failure by 
> nlmsg_alloc()
>  cqm will pass to NLA_PUT_U32. it should not happen.

Same here - use a single-line subject such as

iw: check nlmsg_allocation()

and put more detail in the the body.

johannes

