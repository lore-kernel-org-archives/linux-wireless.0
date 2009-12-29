Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:40303 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbZL2UqJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Dec 2009 15:46:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	Greg KH <gregkh@suse.de>
Subject: Re: 2.6.33-rc2: Reported regressions from 2.6.32
Date: Tue, 29 Dec 2009 21:46:35 +0100
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Adrian Bunk <bunk@kernel.org>,
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
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <b170af450912291200r73a56d55n5e9a68043a503907@mail.gmail.com>
In-Reply-To: <b170af450912291200r73a56d55n5e9a68043a503907@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200912292146.35119.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 29 December 2009, Rafał Miłecki wrote:
> 2009/12/29 Rafael J. Wysocki <rjw@sisk.pl>:
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14910
> > Subject         : Stable version 2.6.32.2 broke my KMS Radeon setup
> > Submitter       : Ruud Linders <kernelml@xs4all.nl>
> > Date            : 2009-12-20 12:02 (10 days old)
> > References      : http://marc.info/?l=linux-kernel&m=126131105608871&w=4
> 
> Has patch (I think it was even submitted to Linus).

This is a -stable only issue in fact, so I'm not going to track it from now on.

Please watch the next -stable announcement from Greg and remind him about this
issue if the patch isn't there.

Rafael
