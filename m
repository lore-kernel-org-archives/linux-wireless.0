Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46940 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbbHMIyI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 04:54:08 -0400
Message-ID: <1439456046.2114.3.camel@sipsolutions.net> (sfid-20150813_105420_115465_D7B65FAA)
Subject: Re: [PATCH 3/4] iw: Static analyser report that attr may be NULL so
 either we can remove condition check statement or add goto at end of this
 function.
From: Johannes Berg <johannes@sipsolutions.net>
To: amit.khatri@samsung.com
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Rahul Jain <rahul.jain@samsung.com>,
	HEMANSHU SRIVASTAVA <hemanshu.s@samsung.com>,
	Nitin Jhanwar <nitin.j@samsung.com>
Date: Thu, 13 Aug 2015 10:54:06 +0200
In-Reply-To: <1851474397.309551435309952587.JavaMail.weblogic@ep2mlwas06c>
References: <1851474397.309551435309952587.JavaMail.weblogic@ep2mlwas06c>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-06-26 at 09:12 +0000, Amit Khatri wrote:
> Hi Johannes,
> 
> Subject: [PATCH 3/4] iw: Static analyser report that attr may be NULL 
> so
>  either we can remove condition check statement or add goto at end of 
> this
>  function.
> 
That's far far too much for the subject.

Please submit properly formatted patches with a single-line subject and
a more detailed description in the body.

> + out:
> +       ;  /*empty statement to avoid compiler error */
>  }

Just doing "return;" instead of "goto out;" would seem more reasonable
than all these contortions?

johannes
