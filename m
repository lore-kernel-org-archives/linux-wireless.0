Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atlantis.8hz.com ([212.129.237.78]:50327 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbYJVIaD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 04:30:03 -0400
Date: Wed, 22 Oct 2008 08:05:57 +0000
From: Sean Young <sean@mess.org>
To: Chr <chunkeey@web.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
Subject: Re: [RFT/RFC][PATCH] p54: fix misbehavings when firmware can't be found
Message-ID: <20081022080557.GA38534@atlantis.8hz.com> (sfid-20081022_103008_481629_96F47D2C)
References: <bug-11782-10286@http.bugzilla.kernel.org/> <20081021112313.0885a745.akpm@linux-foundation.org> <200810212156.24772.chunkeey@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200810212156.24772.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 21, 2008 at 09:56:24PM +0200, Chr wrote:
> On Tuesday 21 October 2008 20:23:13 Andrew Morton wrote:
> > (switched to email.  Please respond via emailed reply-to-all, not via the
> > bugzilla web interface).
> >
> > On Sat, 18 Oct 2008 09:13:00 -0700 (PDT)
> >
> > bugme-daemon@bugzilla.kernel.org wrote:
> > > http://bugzilla.kernel.org/show_bug.cgi?id=11782
> > >
> > >            Summary: p54 misbehaves when firmware can't be found
> > >            Product: Drivers
> > >            Version: 2.5
> > >      KernelVersion: 2.6.27-git8
> > >           Platform: All
> > >         OS/Version: Linux
> > >               Tree: Mainline
> > >             Status: NEW
> > >           Severity: low
> > >           Priority: P1
> > >          Component: network-wireless
> > >         AssignedTo: drivers_network-wireless@kernel-bugs.osdl.org
> > >         ReportedBy: sean@mess.org
> > >
> > >
> > > Latest working kernel version: 2.6.26
> >
> well, you can increase 26 to 27. The patch that caused this regression 
> went into in 2.6.27-gitX so no stable kernel is affected only this pre-rc1...
> 
> anyway, I don't have any p54p hardware right now (for the next two weeks
> to be more precise), so sean you have to test it and report back, otherwise
> this will properly stay RFT...
> 
> I made two versions of the patch, both do the same,
> so it more a matter of which one you would like to have.
> 
> I prefer the first and bigger one, since it hopefully won't break the other 
> patches I send some time ago for wireless-testing...

Both patches work. I tested both patches with the firmware not in place 
(no stack trace) and in place (works as expected).

Thanks
Sean
