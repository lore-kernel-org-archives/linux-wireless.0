Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42563 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757734Ab0GWOVX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 10:21:23 -0400
Message-ID: <4C49A577.3020306@lwfinger.net>
Date: Fri, 23 Jul 2010 09:21:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	Linux ACPI <linux-acpi@vger.kernel.org>,
	Linux PM List <linux-pm@lists.linux-foundation.org>,
	Linux SCSI List <linux-scsi@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	DRI <dri-devel@lists.freedesktop.org>
Subject: Re: 2.6.35-rc6: Reported regressions from 2.6.34
References: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>
In-Reply-To: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/23/2010 06:42 AM, Rafael J. Wysocki wrote:
> This message contains a list of some regressions from 2.6.34,
> for which there are no fixes in the mainline known to the tracking team.
> If any of them have been fixed already, please let us know.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16312
> Subject		: WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
> Submitter	: Zdenek Kabelac<zdenek.kabelac@gmail.com>
> Date		: 2010-06-28 9:40 (26 days old)
> Message-ID	:<AANLkTin24fr5O4_q5Xbo9Y_NKkEmtcp6Hgmr9_4qXaFz@mail.gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=127771804806465&w=2

I still have this in 2.6.35-rc5.

Larry
