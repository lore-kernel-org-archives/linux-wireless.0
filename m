Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f172.google.com ([209.85.221.172]:52495 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbZJKXZB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 19:25:01 -0400
Message-ID: <4AD26926.9030306@lwfinger.net>
Date: Sun, 11 Oct 2009 18:24:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
In-Reply-To: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/2009 05:41 PM, Rafael J. Wysocki wrote:
> [Note:
>   10 new reports in the last 10 days, but fortunately we're fixing them faster
>   than they're being reported.]

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14181
> Subject		: b43 causes panic at ifconfig down / shutdown
> Submitter	: Jeremy Huddleston <jeremyhu@freedesktop.org>
> Date		: 2009-09-15 18:34 (27 days old)

A patch to fix this one is in the hands of the OP. It should be tested
within the next couple of days.

Larry
