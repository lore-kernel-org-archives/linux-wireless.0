Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab1H1Tfi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Aug 2011 15:35:38 -0400
Date: Sun, 28 Aug 2011 15:35:20 -0400
From: Dave Jones <davej@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Florian Mickler <florian@mickler.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	Linux ACPI <linux-acpi@vger.kernel.org>,
	Linux PM List <linux-pm@lists.linux-foundation.org>,
	Linux SCSI List <linux-scsi@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	DRI <dri-devel@lists.freedesktop.org>
Subject: Re: 3.1-rc3-git6: Reported regressions from 3.0
Message-ID: <20110828193519.GA14132@redhat.com> (sfid-20110828_213556_880242_F1B0D98E)
References: <lx6sezwGldO.A.IhF.UBpWOB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <lx6sezwGldO.A.IhF.UBpWOB@chimera>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 28, 2011 at 08:22:05PM +0200, Rafael J. Wysocki wrote:
 
 > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=41742
 > Subject		: duplicate filename  for intel_backlight with the i915 driver
 > Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
 > Date		: 2011-08-25 18:51 (4 days old)
 > First-Bad-Commit: http://git.kernel.org/linus/aaa6fd2a004147bf32fce05720938236de3361d9
 
this should be fixed by b727d20269e8ef1de002bfea8099f5e9db9e9f23
 
	Dave

