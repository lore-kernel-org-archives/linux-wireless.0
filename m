Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3732 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab1FNRur (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2011 13:50:47 -0400
Date: Tue, 14 Jun 2011 10:50:36 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "Dan Carpenter" <error27@gmail.com>
cc: "julie Sullivan" <kernelmail.jms@gmail.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH 00/21] staging: brcm80211: code cleanup and fullmac
 bugfix
Message-ID: <20110614175035.GE9280@broadcom.com> (sfid-20110614_195050_403539_F846A4E7)
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
 <20110609185420.GK4069@shale.localdomain>
 <BANLkTi=FuX0H3UOi6M_LL5t5hdDen77WcQ@mail.gmail.com>
 <4DF1D0A5.8080300@broadcom.com>
 <BANLkTi=bVse-E2Gc+ArN8AyS3JwZNAPzmA@mail.gmail.com>
 <20110612190045.GB3583@shale.localdomain>
MIME-Version: 1.0
In-Reply-To: <20110612190045.GB3583@shale.localdomain>
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 12, 2011 at 12:00:45PM -0700, Dan Carpenter wrote:
> On Sun, Jun 12, 2011 at 07:23:27PM +0100, julie Sullivan wrote:
> > > I am using GregKH's staging-next repo:
> > > git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6.git
> > >
> > 
> > > The patch applies on top of 5ad7b85b90e30eb5af4fbf6ce21907a2bd8934df.
> > >
> > > Bye, Roland.
> > >
> > 
> > OK, this compiles fine on x86-64/SMP. It's probably not interesting
> > but there are just a few warnings:
> >
> 
> Yeah.  The driver only works under 32 bit.  This is listed in the
> TODO file as something to fix before it leaves staging.
> 

At the moment, we haven't really seen any interest in 64-bit support with sdio
(almost all actual usage is 32-bit ARM as far as I can tell), but it will
definitely get more relevant when we add USB support to brcmfmac.  We'll work
on getting it up and running, but any help would be appreciated.

Is it safe to assume the related modules (mmc.ko, etc) work on 64-bit?

- Henry


