Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab1GAAQP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 20:16:15 -0400
Date: Thu, 30 Jun 2011 17:14:57 -0700
From: Greg KH <gregkh@suse.de>
To: Dan Carpenter <error27@gmail.com>
Cc: Henry Ptasinski <henryp@broadcom.com>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH 000/119] staging: brcm80211: more code cleanup and bug
 fixed
Message-ID: <20110701001457.GB934@suse.de> (sfid-20110701_021620_738732_638E76F4)
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
 <BANLkTikPBWvYiNc1rZEwPJTck=AzUsLncA@mail.gmail.com>
 <4E0CB587.3000209@broadcom.com>
 <20110630183258.GB2544@shale.localdomain>
 <4E0CED43.50305@broadcom.com>
 <20110701000526.GD2544@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110701000526.GD2544@shale.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 01, 2011 at 03:05:26AM +0300, Dan Carpenter wrote:
> On Thu, Jun 30, 2011 at 02:40:19PM -0700, Henry Ptasinski wrote:
> > So there are two suggestions here:
> > 
> > 1. post patches in smaller bunches, and include dependency info in
> > the 0/X patch.  Presumably, if one of the dependencies is dropped,
> > then people will know to drop this series as well, and we would have
> > to repost everything that was dropped once we fix the identified
> > issues.
> > 
> > 2. maintain a public git tree that people can pull from.  If we do
> > (1), is this needed and/or still useful?
> 
> Yes.  Patches hiding in git trees never get reviewed.  They just
> pile up until there too many to review.
> 
> > Do community folks that
> > want to contribute changes send them to us or Greg/John/whoever is
> > upstream? Pros/cons?
> 
> That stuff is between you and Greg.  The rest of us don't care.
> 
> But what I'm saying is don't delay sending these patches because
> you're not sure if the other patches were going to go in or not.
> It's not an unpredictable thing.  Everyone is supposed to CC you
> along with Greg, linux-wireless and driver-devel.  You're the
> maintainer.  If you ack a patch or nack it, then 99% of the time
> Greg is going to go along with your decision.
> 
> It's not like Greg is going to complain if you start recording which
> patches have to go in next and deal with any merge conflicts...

Nope, Greg would be very happy and hopefully have to stop referring to
himself in the third person if people were so kind.

thanks,

greg 'sorry, it's been a long day staring at usb 3.0 patches...' k-h
