Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34359 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab1FLTBM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jun 2011 15:01:12 -0400
Received: by pzk9 with SMTP id 9so1856842pzk.19
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jun 2011 12:01:12 -0700 (PDT)
Date: Sun, 12 Jun 2011 22:00:45 +0300
From: Dan Carpenter <error27@gmail.com>
To: julie Sullivan <kernelmail.jms@gmail.com>
Cc: Roland Vossen <rvossen@broadcom.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/21] staging: brcm80211: code cleanup and fullmac bugfix
Message-ID: <20110612190045.GB3583@shale.localdomain> (sfid-20110612_210116_394708_17E8C41E)
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
 <20110609185420.GK4069@shale.localdomain>
 <BANLkTi=FuX0H3UOi6M_LL5t5hdDen77WcQ@mail.gmail.com>
 <4DF1D0A5.8080300@broadcom.com>
 <BANLkTi=bVse-E2Gc+ArN8AyS3JwZNAPzmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BANLkTi=bVse-E2Gc+ArN8AyS3JwZNAPzmA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 12, 2011 at 07:23:27PM +0100, julie Sullivan wrote:
> > I am using GregKH's staging-next repo:
> > git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6.git
> >
> 
> > The patch applies on top of 5ad7b85b90e30eb5af4fbf6ce21907a2bd8934df.
> >
> > Bye, Roland.
> >
> 
> OK, this compiles fine on x86-64/SMP. It's probably not interesting
> but there are just a few warnings:
>

Yeah.  The driver only works under 32 bit.  This is listed in the
TODO file as something to fix before it leaves staging.

regards,
dan carpenter

