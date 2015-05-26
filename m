Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30645 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbbEZUKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 16:10:17 -0400
Date: Tue, 26 May 2015 23:09:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	devel@driverdev.osuosl.org,
	Sudip Mukherjee <sudip@vectorindia.org>,
	linux-wireless@vger.kernel.org, Stable <stable@vger.kernel.org>,
	netdev@vger.kernel.org, Haggai Eran <haggai.eran@gmail.com>,
	Arek Rusniak <arek.rusi@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] staging: r8712u: Fix kernel warning for improper call of
 del_timer_sync()
Message-ID: <20150526200941.GC11734@mwanda> (sfid-20150526_221029_025229_ECB5FC62)
References: <556268BC.5050807@lwfinger.net>
 <20150525091737.GQ4150@mwanda>
 <1432575448.2846.63.camel@perches.com>
 <20150526044611.GA3465@sudip-PC>
 <1432616108.2846.83.camel@perches.com>
 <20150526050212.GC3465@sudip-PC>
 <1432616879.2846.86.camel@perches.com>
 <20150526141401.GC21573@kroah.com>
 <1432651739.2846.93.camel@perches.com>
 <20150526163555.GA9685@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150526163555.GA9685@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 26, 2015 at 09:35:55AM -0700, Greg KH wrote:
> Also, the outreachy patch process would overwhelm everyone else on the
> list, it's really high volume during the application phase, I'd prefer
> it to stick with the mentors that wish to help out with the process.  If
> you and/or Dan, or anyone else wishes to help out with this, I would
> really appreciate it.  But I don't think that forcing them to post to
> the driverdevel list is a good idea.

If it makes your life easier to merge them directly from outreachy
that's great and I'm ok with that, but don't skip the normal review
process as a favour to us.

regards,
dan carpenter

