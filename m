Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:40286 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578Ab0LQWbn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 17:31:43 -0500
Subject: Re: new iwlwifi 6030 uCode available
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <AANLkTi=LmzQVzUruEQAjcSOEjy+x3U_9DqF4tLHENAcU@mail.gmail.com>
References: <1292620126.22230.12.camel@wwguy-ubuntu>
	 <AANLkTinWma9xFSUe9ShdVWWRYsFtDVcAoacZAg4RMXA+@mail.gmail.com>
	 <AANLkTi=LmzQVzUruEQAjcSOEjy+x3U_9DqF4tLHENAcU@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Dec 2010 14:30:36 -0800
Message-Id: <1292625036.22230.21.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

On Fri, 2010-12-17 at 14:19 -0800, Daniel Halperin wrote:
> 2010/12/17 Rafał Miłecki <zajec5@gmail.com>:
> > 2010/12/17 Guy, Wey-Yi <wey-yi.w.guy@intel.com>:
> >> Version 17.168.5.1 of uCode for Intel Intel@ 6030 Series Wi-Fi Adapters
> >> is now available for download from
> >> http://intellinuxwireless.org/?n=Downloads
> >
> > I want uCode for 5100 to resolve
> > http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2214 !
> >
> > Damn, do you want us to RE Intel's firmware or what? Is that your policy?
> 
> Hi Wey-Yi,
> 
> I noticed from this bug report that the workaround is to disable
> 802.11n.  Is it not possible to instead force-stop all queues, restart
> the firmware and driver similar to when uCode crashes?  This might
> tide Rafal over for a little while.  It looks like he's not planning
> to stop trolling every few days despite your giving the same answer
> that the issue is out of your control.
> 
> Alternatively, Rafal, you might try to implement this type of fix.
> 
I thought about that and I even have the patch for it, but it works
sometime and not the other and it is not stable, that is why I did not
push upstream, I might need to spend more time to figure out what is
going on there. Just don't have much time in the past few weeks/months.

Thank
Wey

