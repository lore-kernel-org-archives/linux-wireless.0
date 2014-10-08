Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42116 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbaJHNSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 09:18:10 -0400
Date: Wed, 8 Oct 2014 16:17:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	linux-wireless@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joe Perches <joe@perches.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [patch] staging: rtl8723au: incorrect use of ether_addr_copy()
Message-ID: <20141008131739.GD26918@mwanda> (sfid-20141008_151816_587060_BB372C8C)
References: <20141008104014.GA23096@mwanda>
 <1412771171.3438.25.camel@joe-AO725>
 <20141008124631.GC26918@mwanda>
 <alpine.DEB.2.10.1410081449160.2441@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.DEB.2.10.1410081449160.2441@hadrien>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 08, 2014 at 02:50:50PM +0200, Julia Lawall wrote:
> Couldn't you just use your favorite matching tool, collect the file names,
> compile them, run pahole, and process the output in some way?  It doesn't
> give a complete analysis (you don't find all problems), but if you find a
> problem it is a real problem.

Well...  You would be better off using Smatch than pahole.  And
obviously I did try something like this, but it's fairly tricky.

regards,
dan carpenter

