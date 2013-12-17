Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38206 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab3LQJcT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 04:32:19 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Henrik Austad <henrik@austad.us>,
	Emmanuel Grumbach <egrumbach@gmail.com>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC 00/10] make iwlwifi RT friendly
Date: Tue, 17 Dec 2013 09:32:14 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303D2233A@HASMSX103.ger.corp.intel.com> (sfid-20131217_103229_765975_FD4B549D)
References: <1386750826-25219-1-git-send-email-emmanuel.grumbach@intel.com>
 <20131215154843.GL31090@linutronix.de> <52ADEAAF.3080107@gmail.com>
 <52ADEB0D.3080306@linutronix.de> <52ADEBDF.5060406@gmail.com>
 <20131217092120.GA28480@austad.us>
In-Reply-To: <20131217092120.GA28480@austad.us>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> On Sun, Dec 15, 2013 at 07:50:23PM +0200, Emmanuel Grumbach wrote:
> >
> >
> > On 12/15/2013 07:46 PM, Sebastian Andrzej Siewior wrote:
> > > On 12/15/2013 06:45 PM, Emmanuel Grumbach wrote:
> > >> No we don't. The primary interrupt just tells the hardware to stop
> > >> firing interrupts and wakes up the thread as written above.
> > >
> > > Sounds great then.
> > >
> >
> > Ok - I guess I'll submit then internally then before we send them upstream.
> 
> I'm trying to mash this on top of 3.12.5 for the latest rt-release, and especially
> drivers/net/wireless/iwlwifi/pcie/rx.c is not particularly compatible with your
> patches, especially iwl_pcie_int_cause_non_ict(), which as been moved,
> renamed and given new return values.

iwl_pcie_int_cause_non_ict didn't exist before my patch. I am not sure I follow here...
I am not sure I'll have the time to fulfill your request, but I'll try.

> 
> Especially 07 is giving me some headaches, and instead of me making a
> massive trainwreck of it all, would you mind moving this closer to 3.12?
> 
> Thanks!
> 
> --
> Henrik Austad
