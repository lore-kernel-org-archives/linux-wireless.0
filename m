Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f173.google.com ([209.85.216.173]:33626 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932665Ab0BPUI4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 15:08:56 -0500
Received: by pxi3 with SMTP id 3so2846713pxi.28
        for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2010 12:08:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <fQEllunEdO.A.-LB.HyIeLB@chimera>
References: <fQEllunEdO.A.-LB.HyIeLB@chimera>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 16 Feb 2010 12:08:35 -0800
Message-ID: <43e72e891002161208j29df68c8q443d97eeeb89e72d@mail.gmail.com>
Subject: Re: 2.6.33-rc8: Reported regressions 2.6.31 -> 2.6.32
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Miles Lane <miles.lane@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 14, 2010 at 3:46 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message contains a list of some post-2.6.31 regressions introduced before
> 2.6.32, for which there are no fixes in the mainline known to the tracking team.
> If any of them have been fixed already, please let us know.

> Unresolved regressions
> ----------------------

Only one for 802.11:

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14624
> Subject         : ath9k: BUG kmalloc-8192: Poison overwritten
> Submitter       : Miles Lane <miles.lane@gmail.com>
> Date            : 2009-11-12 4:58 (95 days old)
> References      : http://marc.info/?l=linux-kernel&m=125800196520396&w=4
>

We still have no steps to reproduce :T

  Luis
