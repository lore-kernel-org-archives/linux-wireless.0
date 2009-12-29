Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:40611 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbZL2VtN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Dec 2009 16:49:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jarek Poplawski <jarkao2@gmail.com>
Subject: Re: 2.6.33-rc2: Reported regressions 2.6.31 -> 2.6.32
Date: Tue, 29 Dec 2009 22:49:48 +0100
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
	DRI <dri-devel@lists.sourceforge.net>,
	=?utf-8?q?M=C3=A1rton_N=C3=A9meth?= <nm127@freemail.hu>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera> <4B3A5BC2.10207@gmail.com>
In-Reply-To: <4B3A5BC2.10207@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200912292249.48496.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 29 December 2009, Jarek Poplawski wrote:
> Rafael J. Wysocki wrote, On 12/29/2009 04:26 PM:
> 
> ...
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14794
> > Subject		: IP address assigned by DHCP is dropped after ~40 seconds
> > Submitter	: Márton Németh <nm127@freemail.hu>
> > Date		: 2009-12-13 08:59 (17 days old)
> > 
> 
> 
> IMHO this bug might be considered as fixed by updating a userspace tool
> (KNetworkManager) - unless somebody wants to seek for the exact reason...

Good, I'll gladly close it. :-)

Rafael
