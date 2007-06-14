Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:27343 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbXFNH5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 03:57:23 -0400
Received: by nf-out-0910.google.com with SMTP id g13so15972nfb
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2007 00:57:22 -0700 (PDT)
From: Paulo Pereira <pfmp.404@gmail.com>
To: Greg KH <gregkh@suse.de>
Subject: Re: [2/2] 2.6.22-rc4: known regressions with patches v3
Date: Thu, 14 Jun 2007 08:57:14 +0100
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <samuel@sortiz.org>,
	Andrey Borzenkov <arvidjaar@mail.ru>,
	Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	James Morris <jmorris@namei.org>,
	Eric Paris <eparis@parisplace.org>,
	Ingo Molnar <mingo@elte.hu>,
	Alan Stern <stern@rowland.harvard.edu>
References: <46704B5D.5020106@googlemail.com> <46704C4D.5010803@googlemail.com> <20070613203501.GA5708@suse.de>
In-Reply-To: <20070613203501.GA5708@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200706140857.14824.pfmp.404@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A Wednesday 13 June 2007 21:35:02, Greg KH escreveu:
> On Wed, Jun 13, 2007 at 09:58:05PM +0200, Michal Piotrowski wrote:
> >  USB
> >
> >  Subject    : list_add corruption. prev->next should be next (f7d28794),
> > but was f0df8ed4 (prev=f0df8ed4) Kernel Bug at lib/list_debug.c:33
> >  References : http://bugzilla.kernel.org/show_bug.cgi?id=8561
> >  Submitter  : Paulo Pereira <pfmp.404@gmail.com>
> >  Handled-By : Alan Stern <stern@rowland.harvard.edu>
> >  Patch      : http://bugzilla.kernel.org/show_bug.cgi?id=8561#c8
> >  Status     : patch was suggested
>
> I'm pretty sure this wasn't a "regression" and was always there, and
> that the proposed patch did fix the solution, right Paulo and Alan?
>
> thanks,
>
> greg k-h

	No I haven't fix the problem... I'am waiting for a friend that is in 
holiday's and work's with linux well. I'am beginer in linux and I can't put 
the patch to work, because of that I'am waiting for him to see if the patch 
work. 
	Sorry, the fact I don't say anything about the problem but my friend comes 
this week and them we put the patch and I will tell something!!
Regards, Paulo.
