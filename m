Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20233 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab3J2UKP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 16:10:15 -0400
Date: Tue, 29 Oct 2013 23:09:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, security@kernel.org,
	Nico Golde <nico@ngolde.de>, Fabian Yamaguchi <fabs@goesec.de>
Subject: Re: [patch] libertas: potential oops in debugfs
Message-ID: <20131029200924.GF20521@mwanda> (sfid-20131029_211024_728927_E49AF714)
References: <20131025144452.GA28451@ngolde.de>
 <20131029190641.GB21820@longonot.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131029190641.GB21820@longonot.mountain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 29, 2013 at 10:06:41PM +0300, Dan Carpenter wrote:
> If we do a zero size write then it will oops.  This can only be
> triggered by root.
> 

This one isn't right...  Sorry for that.  We do need to fix the while
loop.  I wasn't thinking.

I will resend.

regards,
dan carpenter

