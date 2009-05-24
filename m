Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comar.pardus.org.tr ([193.140.100.220]:42263 "EHLO
	pardus.org.tr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754581AbZEXWHW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 May 2009 18:07:22 -0400
Message-ID: <4A19C51D.7020609@pardus.org.tr>
Date: Mon, 25 May 2009 01:07:25 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
Subject: Re: 2.6.30-rc7: Reported regressions from 2.6.29
References: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera>
In-Reply-To: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13326
> Subject		: [PATCH]Null pointer dereference in rtc-cmos driver
> Submitter	: Ozan Çağlayan <ozan@pardus.org.tr>
> Date		: 2009-05-14 16:16 (11 days old)
> References	: http://marc.info/?l=linux-kernel&m=124231783704696&w=4
>   

Just to notice that the patch for this is at:

http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/driver-core.current/driver-core-do-not-oops-when-driver_unregister-is-called-for-unregistered-drivers.patch

Can at least be marked as "has a patch".

Thanks,
Ozan Caglayan
