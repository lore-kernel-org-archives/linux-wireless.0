Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54949 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932537AbbEZOOE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 10:14:04 -0400
Date: Tue, 26 May 2015 07:14:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	devel@driverdev.osuosl.org,
	Sudip Mukherjee <sudip@vectorindia.org>,
	linux-wireless@vger.kernel.org, Stable <stable@vger.kernel.org>,
	netdev@vger.kernel.org, Haggai Eran <haggai.eran@gmail.com>,
	Arek Rusniak <arek.rusi@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] staging: r8712u: Fix kernel warning for improper call of
 del_timer_sync()
Message-ID: <20150526141401.GC21573@kroah.com> (sfid-20150526_161433_938382_5D04C9E1)
References: <1432415812-1285-1-git-send-email-Larry.Finger@lwfinger.net>
 <CAJ=9CzbPmo+f4zjY4CqQ7TsUENpwy+zHcpxeLTbAH0DAZSkqsQ@mail.gmail.com>
 <556268BC.5050807@lwfinger.net>
 <20150525091737.GQ4150@mwanda>
 <1432575448.2846.63.camel@perches.com>
 <20150526044611.GA3465@sudip-PC>
 <1432616108.2846.83.camel@perches.com>
 <20150526050212.GC3465@sudip-PC>
 <1432616879.2846.86.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1432616879.2846.86.camel@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 25, 2015 at 10:07:59PM -0700, Joe Perches wrote:
> On Tue, 2015-05-26 at 10:32 +0530, Sudip Mukherjee wrote:
> > On Mon, May 25, 2015 at 09:55:08PM -0700, Joe Perches wrote:
> > > On Tue, 2015-05-26 at 10:16 +0530, Sudip Mukherjee wrote:
> > > > On Mon, May 25, 2015 at 10:37:28AM -0700, Joe Perches wrote:
> > > > > It'd be better if the approved patches from the intern list
> > > > > (no idea what that is) were sent to lkml/devel@driverdev lists
> > > > > for review before actually being applied.
> > > > Its the outreachy program. And http://kernelnewbies.org/OutreachyApply
> > > > mentions specifically: "email your first patch to the outreachy-kernel
> > > > mailing list. Do not send patches to the tmain Linux mailing lists"
> > > 
> > > The same thing happens with the eudyptula patches.
> > But for eudyptula, patches have to properly submitted to lkml and
> > maintainers. And today I am here just because of eudyptula. My patches
> > and contributions here, everything started with it. :)
> 
> As far as I understand, the Eudyptula Challenge list has
> internal mechanisms to nominally review patches before some
> patch is submitted to lkml.

No it does not.

> The main point is that patches shouldn't be applied without
> being submitted to a more widely read list.

I take the blame for any problems with Outreachy patches.  Given the
huge volume of them, one bug out of 900 isn't that bad of a percentage.

thanks,

greg k-h
