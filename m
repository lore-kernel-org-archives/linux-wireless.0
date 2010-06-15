Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58718 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab0FOUAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 16:00:13 -0400
Date: Tue, 15 Jun 2010 15:46:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Leann Ogasawara <leann.ogasawara@canonical.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, flamingice@sourmilk.net,
	linux-wireless@vger.kernel.org,
	Ben Collins <ben.collins@ubuntu.com>
Subject: Re: [PATCH] p54usb: Remove duplicate Medion MD40900 device id
Message-ID: <20100615194610.GB2415@tuxdriver.com>
References: <1276208913.1221.3646.camel@emiko>
 <4C1173E7.6010201@lwfinger.net>
 <20100614185549.GB2216@tuxdriver.com>
 <1276624745.6127.61.camel@emiko>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1276624745.6127.61.camel@emiko>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 15, 2010 at 10:59:05AM -0700, Leann Ogasawara wrote:
> On Mon, 2010-06-14 at 14:55 -0400, John W. Linville wrote:

> > So, I guess you are concerned about the groupings because of the
> > different firmwares or something like that?  Perhaps a comment that
> > says "this could be a version 2 device" is just as handy?  Since the
> > driver prints the name of the firmware it wants, is there any real
> > need for grouping the IDs?
> > 
> > OTOH, is there any actual harm from the duplicate entry?  It "seems"
> > wrong to me too, but I guess it does no harm...?
> 
> I don't believe there is any harm from the duplicate entry, it just
> seemed unnecessary.
> 
> > Leann and/or Ben, was this just tidying-up?  I'm guessing there wasn't
> > an actual bug involved?
> 
> Indeed, this was just a patch we'd been carrying to tidy things up.
> There was no actual bug involved.  I'd be happy to send a v2 of the
> patch which comments out the duplicate entry and adds a note as to why.
> Or I'd be fine just leaving the code as is and we'll drop the patch
> we're carrying locally in Ubuntu.

FWIW, I like the 'comment-out and add a note' option.

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
