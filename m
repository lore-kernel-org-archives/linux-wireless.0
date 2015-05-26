Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0014.hostedemail.com ([216.40.44.14]:41799 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751194AbbEZEzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 00:55:12 -0400
Message-ID: <1432616108.2846.83.camel@perches.com> (sfid-20150526_065523_707386_AF4D570B)
Subject: Re: [PATCH] staging: r8712u: Fix kernel warning for improper call
 of del_timer_sync()
From: Joe Perches <joe@perches.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	devel@driverdev.osuosl.org,
	Sudip Mukherjee <sudip@vectorindia.org>,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	Stable <stable@vger.kernel.org>, netdev@vger.kernel.org,
	Haggai Eran <haggai.eran@gmail.com>,
	Arek Rusniak <arek.rusi@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Date: Mon, 25 May 2015 21:55:08 -0700
In-Reply-To: <20150526044611.GA3465@sudip-PC>
References: <1432415812-1285-1-git-send-email-Larry.Finger@lwfinger.net>
	 <CAJ=9CzbPmo+f4zjY4CqQ7TsUENpwy+zHcpxeLTbAH0DAZSkqsQ@mail.gmail.com>
	 <556268BC.5050807@lwfinger.net> <20150525091737.GQ4150@mwanda>
	 <1432575448.2846.63.camel@perches.com> <20150526044611.GA3465@sudip-PC>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-05-26 at 10:16 +0530, Sudip Mukherjee wrote:
> On Mon, May 25, 2015 at 10:37:28AM -0700, Joe Perches wrote:
> > It'd be better if the approved patches from the intern list
> > (no idea what that is) were sent to lkml/devel@driverdev lists
> > for review before actually being applied.
> Its the outreachy program. And http://kernelnewbies.org/OutreachyApply
> mentions specifically: "email your first patch to the outreachy-kernel
> mailing list. Do not send patches to the tmain Linux mailing lists"

The same thing happens with the eudyptula patches.

That doesn't at all make applying those novice patches
without review by a more widely read list any more sensible.


