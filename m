Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:55972 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707Ab0BVU53 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 15:57:29 -0500
Subject: Re: 2.6.33-rc8-git6: Reported regressions 2.6.31 -> 2.6.32
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Miles Lane <miles.lane@gmail.com>
In-Reply-To: <43e72e891002221009p2d6b14a1xfe04efaad8426033@mail.gmail.com>
References: <4u4d-2M3yXH.A.XW.XqagLB@chimera>
	 <43e72e891002221009p2d6b14a1xfe04efaad8426033@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 22 Feb 2010 15:57:16 -0500
Message-Id: <1266872236.2594.38.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-02-22 at 10:09 -0800, Luis R. Rodriguez wrote:
> Just one but no word yet on how to reproduce.
> 
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14624
> > Subject         : ath9k: BUG kmalloc-8192: Poison overwritten
> > Submitter       : Miles Lane <miles.lane@gmail.com>
> > Date            : 2009-11-12 4:58 (102 days old)
> > References      : http://marc.info/?l=linux-kernel&m=125800196520396&w=4

I could try a 32 bit kernel or that version with the kernel config as
close as possible to the posted one.  But I need at least the minimal
information on how to reproduce the bug.  What mode is used (station,
AP, ad-hoc)?  What encryption is used?  Is there anything else that
could help reproduce the bug?

It would be a waste of time to set up a 32-bit OS and fail to find the
bug just because I'm using a different encryption or something.

-- 
Regards,
Pavel Roskin
