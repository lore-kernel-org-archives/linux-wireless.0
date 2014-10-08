Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41953 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137AbaJHMqt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 08:46:49 -0400
Date: Wed, 8 Oct 2014 15:46:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] staging: rtl8723au: incorrect use of ether_addr_copy()
Message-ID: <20141008124631.GC26918@mwanda> (sfid-20141008_144654_444154_DBC97CA5)
References: <20141008104014.GA23096@mwanda>
 <1412771171.3438.25.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1412771171.3438.25.camel@joe-AO725>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 08, 2014 at 05:26:11AM -0700, Joe Perches wrote:
> On Wed, 2014-10-08 at 13:40 +0300, Dan Carpenter wrote:
> > The return from myid() isn't aligned correctly for ether_addr_copy().
> 
> Hey Dan.
> 
> Actual evidence showing ether_addr_copy conversions
> may not always be wise.
> 
> How did you find them?

I was just trying to see how common these kinds of bugs are.  It didn't
take long to find, but my impression is that they are rare and I got
lucky.  These kinds of bugs are tricky to find and we don't have any
tools for it.

regards,
dan carpenter

