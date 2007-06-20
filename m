Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:46947 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbXFTNhn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2007 09:37:43 -0400
Received: by py-out-1112.google.com with SMTP id a29so346445pyi
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2007 06:37:42 -0700 (PDT)
Message-ID: <6bffcb0e0706200637m33b02ea7le7c8f64c66e159b2@mail.gmail.com>
Date: Wed, 20 Jun 2007 15:37:41 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: [2/2] 2.6.22-rc5: known regressions with patches
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Christoph Lameter" <clameter@sgi.com>,
	"Dave Airlie" <airlied@linux.ie>,
	"Andrea Righi" <righiandr@users.sourceforge.net>,
	Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
	"Samuel Ortiz" <samuel@sortiz.org>,
	"Andrey Borzenkov" <arvidjaar@mail.ru>,
	"Bjorn Helgaas" <bjorn.helgaas@hp.com>,
	"Chad Tindel" <ctindel@users.sourceforge.net>,
	"Dan Aloni" <da-x@monatomic.org>,
	"Jay Vosburgh" <fubar@us.ibm.com>,
	"Stephen Smalley" <sds@tycho.nsa.gov>,
	"James Morris" <jmorris@namei.org>,
	"Eric Paris" <eparis@parisplace.org>,
	"Ingo Molnar" <mingo@elte.hu>,
	linux-usb-devel@lists.sourceforge.net,
	"Greg Kroah-Hartman" <gregkh@suse.de>,
	"Paulo Pereira" <pfmp.404@gmail.com>,
	"Alan Stern" <stern@rowland.harvard.edu>
In-Reply-To: <20070618100905.7fc1176c@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <4675430B.2000304@googlemail.com> <46754400.2080101@googlemail.com>
	 <20070618100905.7fc1176c@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18/06/07, Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> On Sun, 17 Jun 2007 16:24:00 +0200
> Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>
> > Hi all,
> >
> > Here is a list of some known regressions in 2.6.22-rc5
> > with patches available.
> >
> > Feel free to add new regressions/remove fixed etc.
> > http://kernelnewbies.org/known_regressions
> >
> >
> >
> > Memory management
> >
> > Subject    : bug in i386 MTRR initialization
> > References : http://lkml.org/lkml/2007/5/19/93
> > Submitter  : Andrea Righi <righiandr@users.sourceforge.net>
> > Status     : patch available
> >
> >
> >
> > Networking
> > Subject    : commit 9093bbb2d96d0184f037cea9b4e952a44ebe7c32 broke the bonding driver
> > References : http://lkml.org/lkml/2007/6/13/65
> > Submitter  : Dan Aloni <da-x@monatomic.org>
> > Handled-By : Stephen Hemminger <shemminger@linux-foundation.org>
> > Status     : patch available
> >              (I cannot find it in archives. Stephen, please resend the patch)
> >
>
> http://www.mail-archive.com/netdev@vger.kernel.org/msg40352.html

Thanks!

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
