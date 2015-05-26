Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28620 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbbEZU0H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 16:26:07 -0400
Date: Tue, 26 May 2015 23:25:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	devel@driverdev.osuosl.org,
	Sudip Mukherjee <sudip@vectorindia.org>,
	linux-wireless@vger.kernel.org, Stable <stable@vger.kernel.org>,
	netdev@vger.kernel.org, Haggai Eran <haggai.eran@gmail.com>,
	Arek Rusniak <arek.rusi@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] staging: r8712u: Fix kernel warning for improper call of
 del_timer_sync()
Message-ID: <20150526202543.GD11734@mwanda> (sfid-20150526_222613_932248_BC98790B)
References: <20150525091737.GQ4150@mwanda>
 <1432575448.2846.63.camel@perches.com>
 <20150526044611.GA3465@sudip-PC>
 <1432616108.2846.83.camel@perches.com>
 <20150526050212.GC3465@sudip-PC>
 <1432616879.2846.86.camel@perches.com>
 <20150526141401.GC21573@kroah.com>
 <1432651739.2846.93.camel@perches.com>
 <20150526163555.GA9685@kroah.com>
 <1432659977.2846.100.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1432659977.2846.100.camel@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 26, 2015 at 10:06:17AM -0700, Joe Perches wrote:
> If you're collecting them, I suggest you stick them in
> a separate branch, post them to your driverdev list and
> cc the appropriate maintainers, wait a week, then apply
> them to your main branch.

That would work.  A massive thread is easy to delete.  Or even just
apply them first, and we tell people to send follow on patches or revert
as needed.  My whole setup revolves around email so finding and
reviewing patches using git log is awkward.

regards,
dan carpenter

