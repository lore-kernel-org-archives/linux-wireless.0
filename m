Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:23240 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbZKPVG3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 16:06:29 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 14450] New: [2.6.31] Network interfaces are dead with 2.6.31 (iwlagn and sky2)
Date: Mon, 16 Nov 2009 15:06:30 -0600
Cc: orion.linbug@gmail.com, bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, netdev@vger.kernel.org,
	linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-wireless@vger.kernel.org
References: <bug-14450-10286@http.bugzilla.kernel.org/> <20091103152146.5785195a.akpm@linux-foundation.org> <200911040947.28054.bjorn.helgaas@hp.com>
In-Reply-To: <200911040947.28054.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911161406.33473.bjorn.helgaas@hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 04 November 2009 09:47:26 am Bjorn Helgaas wrote:
> On Tuesday 03 November 2009 04:21:46 pm Andrew Morton wrote:
> > 
> > (switched to email.  Please respond via emailed reply-to-all, not via the
> > bugzilla web interface).
> 
> > > http://bugzilla.kernel.org/show_bug.cgi?id=14450
> 
> This looks like a duplicate of http://bugzilla.kernel.org/show_bug.cgi?id=13940
> 
> There's a patch in that bug that is upstream already:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=15b812f1d0a5ca8f5efe7f5882f468af10682ca8
> 
> Please try booting 2.6.31 with "pci=use_crs" and report the result.
> 
> If possible, please also try booting an upstream kernel containing
> the patch above (without "pci=use_crs") and report that result, too.

Ping!  A.G., have you had a chance to try this out?
