Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751383AbYIBASj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2008 20:18:39 -0400
Date: Mon, 1 Sep 2008 17:18:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-wireless@vger.kernel.org
Cc: bugme-daemon@bugzilla.kernel.org,
	"Rafael J. Wysocki" <rjw@sisk.pl>, m.s.tsirkin@gmail.com
Subject: Re: [Bugme-new] [Bug 11476] New: failure to associate after resume
 from suspend to ram
Message-Id: <20080901171817.48743179.akpm@linux-foundation.org> (sfid-20080902_021855_251687_0E5D67DA)
In-Reply-To: <bug-11476-10286@http.bugzilla.kernel.org/>
References: <bug-11476-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Mon,  1 Sep 2008 13:33:47 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11476
> 
>            Summary: failure to associate after resume from suspend to ram
>            Product: Networking
>            Version: 2.5
>      KernelVersion: 2.6.25-rc5
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Wireless
>         AssignedTo: networking_wireless@kernel-bugs.osdl.org
>         ReportedBy: m.s.tsirkin@gmail.com
> 
> 
> Latest working kernel version: 2.6.25-rc4
> Earliest failing kernel version: 2.6.25-rc5

A very recent regression.

> Distribution: ubuntu gutsy
> Hardware Environment: T60p
> Software Environment: self-built kernel, .config attached
> Problem Description:
> 
> Starting with 2.6.27-rc5, my T60p sometimes fails to associate
> with an access point after suspend to ram/resume.
> 
> This does not seem to happen on 2.6.27-rc4.
> 
> Steps to reproduce:
> suspend and resume several times.
> At some point the card fails to associate with
> the AP.

Which device driver is that machine using?
