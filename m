Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:56786 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbZJLMXS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 08:23:18 -0400
Date: Mon, 12 Oct 2009 12:22:01 +0000
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
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
Subject: Re: 2.6.32-rc4: Reported regressions 2.6.30 -> 2.6.31
Message-ID: <20091012122201.GA31282@gambetta>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rafael,

On Mon, Oct 12, 2009 at 12:41:30AM +0200, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14185
> Subject		: Oops in driversbasefirmware_class
> Submitter	:  <lars_ericsson@telia.com>
> Date		: 2009-09-17 05:09 (25 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6e03a201bbe8137487f340d26aa662110e324b20
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14253
> Subject		: Oops in driversbasefirmware_class
> Submitter	: Lars Ericsson <Lars_Ericsson@telia.com>
> Date		: 2009-09-16 20:44 (26 days old)
> References	: http://lkml.org/lkml/2009/9/16/461
> Handled-By	: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
> Patch		: http://patchwork.kernel.org/patch/49914/
> 
Those two are refering to the same bug.

Regards,
Frederik
