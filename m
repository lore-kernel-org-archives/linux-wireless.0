Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [216.40.44.1] ([216.40.44.1]:42278 "EHLO
	smtprelay.hostedemail.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751181AbbEZFIn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 01:08:43 -0400
Message-ID: <1432616879.2846.86.camel@perches.com> (sfid-20150526_070853_791903_0A62F364)
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
Date: Mon, 25 May 2015 22:07:59 -0700
In-Reply-To: <20150526050212.GC3465@sudip-PC>
References: <1432415812-1285-1-git-send-email-Larry.Finger@lwfinger.net>
	 <CAJ=9CzbPmo+f4zjY4CqQ7TsUENpwy+zHcpxeLTbAH0DAZSkqsQ@mail.gmail.com>
	 <556268BC.5050807@lwfinger.net> <20150525091737.GQ4150@mwanda>
	 <1432575448.2846.63.camel@perches.com> <20150526044611.GA3465@sudip-PC>
	 <1432616108.2846.83.camel@perches.com> <20150526050212.GC3465@sudip-PC>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-05-26 at 10:32 +0530, Sudip Mukherjee wrote:
> On Mon, May 25, 2015 at 09:55:08PM -0700, Joe Perches wrote:
> > On Tue, 2015-05-26 at 10:16 +0530, Sudip Mukherjee wrote:
> > > On Mon, May 25, 2015 at 10:37:28AM -0700, Joe Perches wrote:
> > > > It'd be better if the approved patches from the intern list
> > > > (no idea what that is) were sent to lkml/devel@driverdev lists
> > > > for review before actually being applied.
> > > Its the outreachy program. And http://kernelnewbies.org/OutreachyApply
> > > mentions specifically: "email your first patch to the outreachy-kernel
> > > mailing list. Do not send patches to the tmain Linux mailing lists"
> > 
> > The same thing happens with the eudyptula patches.
> But for eudyptula, patches have to properly submitted to lkml and
> maintainers. And today I am here just because of eudyptula. My patches
> and contributions here, everything started with it. :)

As far as I understand, the Eudyptula Challenge list has
internal mechanisms to nominally review patches before some
patch is submitted to lkml.

The main point is that patches shouldn't be applied without
being submitted to a more widely read list.



