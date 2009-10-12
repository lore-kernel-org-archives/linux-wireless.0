Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:36384 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784AbZJLVpK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 17:45:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Subject: Re: 2.6.32-rc4: Reported regressions 2.6.30 -> 2.6.31
Date: Mon, 12 Oct 2009 23:46:11 +0200
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Natalie Protasevich <protasnb@gmail.com>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	Linux ACPI <linux-acpi@vger.kernel.org>,
	Linux PM List <linux-pm@lists.linux-foundation.org>,
	Linux SCSI List <linux-scsi@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	DRI <dri-devel@lists.sourceforge.net>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <20091012122201.GA31282@gambetta>
In-Reply-To: <20091012122201.GA31282@gambetta>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200910122346.11881.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 12 October 2009, Frederik Deweerdt wrote:
> Hi Rafael,
> 
> On Mon, Oct 12, 2009 at 12:41:30AM +0200, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14185
> > Subject		: Oops in driversbasefirmware_class
> > Submitter	:  <lars_ericsson@telia.com>
> > Date		: 2009-09-17 05:09 (25 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6e03a201bbe8137487f340d26aa662110e324b20
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14253
> > Subject		: Oops in driversbasefirmware_class
> > Submitter	: Lars Ericsson <Lars_Ericsson@telia.com>
> > Date		: 2009-09-16 20:44 (26 days old)
> > References	: http://lkml.org/lkml/2009/9/16/461
> > Handled-By	: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
> > Patch		: http://patchwork.kernel.org/patch/49914/
> > 
> Those two are refering to the same bug.

Thanks, I closed #14185 as a duplicate of #14253.

Best,
Rafael
