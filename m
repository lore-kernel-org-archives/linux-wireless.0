Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:52277 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbYIBM73 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 08:59:29 -0400
Received: by ey-out-2122.google.com with SMTP id 6so1169826eyi.37
        for <linux-wireless@vger.kernel.org>; Tue, 02 Sep 2008 05:59:27 -0700 (PDT)
Date: Tue, 2 Sep 2008 15:59:11 +0300
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-wireless@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bugme-new] [Bug 11476] New: failure to associate after resume
	from suspend to ram
Message-ID: <20080902125910.GA19172@google.com> (sfid-20080902_145939_691041_A7FDD7EE)
References: <bug-11476-10286@http.bugzilla.kernel.org/> <20080901171817.48743179.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080901171817.48743179.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 01, 2008 at 05:18:17PM -0700, Andrew Morton wrote:
> 
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
> 
> On Mon,  1 Sep 2008 13:33:47 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=11476
> > 
> >            Summary: failure to associate after resume from suspend to ram
> >            Product: Networking
> >            Version: 2.5
> >      KernelVersion: 2.6.25-rc5
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: Wireless
> >         AssignedTo: networking_wireless@kernel-bugs.osdl.org
> >         ReportedBy: m.s.tsirkin@gmail.com
> > 
> > 
> > Latest working kernel version: 2.6.25-rc4
> > Earliest failing kernel version: 2.6.25-rc5
> 
> A very recent regression.

Seems so.

> > Distribution: ubuntu gutsy
> > Hardware Environment: T60p
> > Software Environment: self-built kernel, .config attached
> > Problem Description:
> > 
> > Starting with 2.6.27-rc5, my T60p sometimes fails to associate
> > with an access point after suspend to ram/resume.
> > 
> > This does not seem to happen on 2.6.27-rc4.
> > 
> > Steps to reproduce:
> > suspend and resume several times.
> > At some point the card fails to associate with
> > the AP.
> 
> Which device driver is that machine using?

iwl3945
